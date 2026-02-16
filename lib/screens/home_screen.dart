import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/screens/welcome_screen.dart';
import '../models/note.dart';
import '../models/note_category.dart';
import '../services/guest_service.dart';
import '../services/notes_manager.dart';
import '../services/auth_service.dart';
import 'notes_list_screen.dart';
import 'dart:async';

class NotesHomeScreen extends StatefulWidget {
  const NotesHomeScreen({super.key});

  @override
  State<NotesHomeScreen> createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  late final NotesManager _notesManager= NotesManager();
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();


  List<Note> _allNotes = [];
  List<Note> _filteredNotes = [];
  List<NoteCategory> _categories = [];

  String? _selectedFilterCategoryId;
  String _sortMethod = 'date_newest';

  // Stream subscriptions
  StreamSubscription<List<Note>>? _notesSubscription;
  StreamSubscription<List<NoteCategory>>? _categoriesSubscription;

  @override
  void initState() {
    super.initState();
    // _notesManager = NotesManager();

    // Ensure default categories exist
    _notesManager.initCategories();



    // Subscribe to notes stream for real-time updates


    _notesSubscription = _notesManager.getNotesStream().listen((notes) {
      setState(() {
        _allNotes = notes;
        _applyFilters();
      });
    });


    // Subscribe to categories stream for real-time updates
    _categoriesSubscription = _notesManager.getCategoriesStream().listen((categories) {
      setState(() {
        _categories = categories;
      });
    });

    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _notesSubscription?.cancel();
    _categoriesSubscription?.cancel();
    _notesManager.dispose();
    super.dispose();
  }

  void _applyFilters() {
    List<Note> notes = _allNotes;

    if (_selectedFilterCategoryId != null) {
      notes = notes.where((note) => note.categoryId == _selectedFilterCategoryId).toList();
    }

    if (_searchController.text.isNotEmpty) {
      notes = notes.where((note) {
        return note.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            note.content.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    }

    _applySorting(notes);
    _filteredNotes = notes;
  }

  void _applySorting(List<Note> notes) {
    switch (_sortMethod) {
      case 'date_newest':
        notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'date_oldest':
        notes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'title_az':
        notes.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case 'category':
        notes.sort((a, b) {
          final catA = _notesManager.getCategoryById(a.categoryId);
          final catB = _notesManager.getCategoryById(b.categoryId);
          final nameA = catA?.name ?? 'Unknown';
          final nameB = catB?.name ?? 'Unknown';
          return nameA.compareTo(nameB);
        });
        break;
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _applyFilters();
    });
  }

  void _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _authService.logout(); // for Firebase users
      await GuestService.clearGuestMode();   // for guest users
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
  }

  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Filter by Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.grid_view, size: 14, color: Colors.black54),
              ),
              title: const Text('All Categories'),
              trailing: _selectedFilterCategoryId == null
                  ? const Icon(Icons.check, color: Color(0xFF7B68AA))
                  : null,
              onTap: () {
                setState(() {
                  _selectedFilterCategoryId = null;
                  _applyFilters();
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ...(_categories.map((category) => ListTile(
              leading: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Color(category.color),
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(category.name),
              trailing: _selectedFilterCategoryId == category.id
                  ? const Icon(Icons.check, color: Color(0xFF7B68AA))
                  : null,
              onTap: () {
                setState(() {
                  _selectedFilterCategoryId = category.id;
                  _applyFilters();
                });
                Navigator.pop(context);
              },
              onLongPress: () async {
                if (category.id == 'none' || category.id == 'default') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cannot delete "${category.name}" category'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                Navigator.pop(context);

                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Category'),
                    content: Text(
                        'Are you sure you want to delete "${category.name}"?\n\nNotes in this category will be moved to "None".'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  final notesInCategory = _allNotes.where((note) => note.categoryId == category.id).toList();
                  for (var note in notesInCategory) {
                    final updatedNote = note.copyWith(categoryId: 'none');
                    await _notesManager.updateNote(updatedNote);  // ✅ correct
                  }

                  await _notesManager.deleteCategory(category.id);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Category "${category.name}" deleted'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
            ))),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sort Notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Color(0xFF7B68AA)),
              title: const Text('Date (Newest First)'),
              trailing: _sortMethod == 'date_newest'
                  ? const Icon(Icons.check, color: Color(0xFF7B68AA))
                  : null,
              onTap: () {
                setState(() {
                  _sortMethod = 'date_newest';
                  _applyFilters();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today_outlined, color: Color(0xFF7B68AA)),
              title: const Text('Date (Oldest First)'),
              trailing: _sortMethod == 'date_oldest'
                  ? const Icon(Icons.check, color: Color(0xFF7B68AA))
                  : null,
              onTap: () {
                setState(() {
                  _sortMethod = 'date_oldest';
                  _applyFilters();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha, color: Color(0xFF7B68AA)),
              title: const Text('Title (A-Z)'),
              trailing: _sortMethod == 'title_az'
                  ? const Icon(Icons.check, color: Color(0xFF7B68AA))
                  : null,
              onTap: () {
                setState(() {
                  _sortMethod = 'title_az';
                  _applyFilters();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.category, color: Color(0xFF7B68AA)),
              title: const Text('Category'),
              trailing: _sortMethod == 'category'
                  ? const Icon(Icons.check, color: Color(0xFF7B68AA))
                  : null,
              onTap: () {
                setState(() {
                  _sortMethod = 'category';
                  _applyFilters();
                });
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = _selectedFilterCategoryId != null
        ? _notesManager.getCategoryById(_selectedFilterCategoryId!)
        : null;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8C5E8),
              Color(0xFFD4A5D4),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Hi, zain',
                            style: TextStyle(fontSize: 16, color: Colors.black87)),
                        Text('Good Morning',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(77),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.grid_view,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _handleLogout,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(77),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.logout,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search, color: Colors.black54),
                      hintText: 'Search note',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _showCategoryFilter,
                      child: Row(
                        children: [
                          Text(
                            selectedCategory != null
                                ? selectedCategory.name
                                : 'All Notes',
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_drop_down, color: Colors.black, size: 28),
                          if (selectedCategory != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Color(selectedCategory.color),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _showSortOptions,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.sort,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _filteredNotes.isEmpty
                      ? Center(
                    child: Text(
                      _searchController.text.isNotEmpty
                          ? 'No notes found'
                          : _selectedFilterCategoryId != null
                          ? 'No notes in this category'
                          : 'No notes yet. Tap + to create one!',
                      style: const TextStyle(
                          fontSize: 16, color: Colors.black54),
                    ),
                  )
                      : ListView.builder(
                    itemCount: _filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = _filteredNotes[index];
                      final category = _notesManager.getCategoryById(note.categoryId);

                      return GestureDetector(
                        onTap: () async {
                          final updatedNote = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NoteEditorScreen(note: note),
                            ),
                          );
                          if (updatedNote != null) {
                            await _notesManager.addNote(updatedNote);
                            // _notesSubscription = _notesManager.getNotesStream().listen((notes) {
                            //   setState(() {
                            //     _allNotes = notes;
                            //     _applyFilters();
                            //   });
                            // });
                          }
                        },
                        onLongPress: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Note'),
                              content: const Text(
                                  'Are you sure you want to delete this note?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            await _notesManager.deleteNote(note.id);
                            // _notesSubscription = _notesManager.getNotesStream().listen((notes) {
                            //   setState(() {
                            //     _allNotes = notes;
                            //     _applyFilters();
                            //   });
                            // });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: index == 0
                                  ? Colors.white
                                  : const Color(0xFFE8D4E8),
                              borderRadius: BorderRadius.circular(16),
                              border: index == 0
                                  ? Border.all(
                                  color: const Color(0xFF7B68AA), width: 2)
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(note.title,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black)),
                                    ),
                                    if (category != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Color(category.color).withAlpha(40),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Color(category.color),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          category.name,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Color(category.color),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(note.content,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black54)),
                                const SizedBox(height: 4),
                                Text(
                                    '${_monthName(note.createdAt.month)} ${note.createdAt.day}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black38)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF9B7FDB), Color(0xFF7B68AA)],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B68AA).withAlpha(102),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: () async {
              final newNote = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NoteEditorScreen()),
              );
              if (newNote != null) {
                await _notesManager.addNote(newNote);
                // _notesSubscription = _notesManager.getNotesStream().listen((notes) {
                //   setState(() {
                //     _allNotes = notes;
                //     _applyFilters();
                //   });
                // });
              }
            },
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}