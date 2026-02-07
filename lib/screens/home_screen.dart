import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';
import '../models/category.dart';
import '../services/category_service.dart';
import '../services/notes_service.dart';
import 'notes_list_screen.dart'; // 👈 FIXED: Changed from 'notes_list_screen.dart'

class NotesHomeScreen extends StatefulWidget {
  const NotesHomeScreen({super.key});

  @override
  State<NotesHomeScreen> createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  late final NotesService _notesService;
  late final CategoryService _categoryService;
  final TextEditingController _searchController = TextEditingController();

  List<Note> _allNotes = [];
  List<Note> _filteredNotes = [];
  late Box<Note> _notesBox;

  String? _selectedFilterCategoryId; // null = show all categories
  String _sortMethod = 'date_newest'; // Default sort: newest first
  // Options: 'date_newest', 'date_oldest', 'title_az', 'category'

  @override
  void initState() {
    super.initState();
    _notesService = NotesService();
    _categoryService = CategoryService();
    _notesBox = Hive.box<Note>('notes');
    _loadNotes();

    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });

    // Listen to box changes and reload notes
    _notesBox.listenable().addListener(() {
      _loadNotes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadNotes() {
    setState(() {
      _allNotes = _notesService.getNotes();
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Note> notes = _allNotes;

    // Filter by category
    if (_selectedFilterCategoryId != null) {
      notes = notes.where((note) => note.categoryId == _selectedFilterCategoryId).toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      notes = notes.where((note) {
        return note.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            note.content.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    }

    // Apply sorting
    _applySorting(notes);

    _filteredNotes = notes;
  }

  void _applySorting(List<Note> notes) {
    switch (_sortMethod) {
      case 'date_newest':
      // Sort by date, newest first
        notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;

      case 'date_oldest':
      // Sort by date, oldest first
        notes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;

      case 'title_az':
      // Sort alphabetically by title
        notes.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;

      case 'category':
      // Sort by category name
        notes.sort((a, b) {
          final catA = _categoryService.getCategoryById(a.categoryId);
          final catB = _categoryService.getCategoryById(b.categoryId);
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

  void _showCategoryFilter() {
    final categories = _categoryService.getCategories();

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
            // All categories option
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
            // 👇 UPDATED: List of categories with long-press delete
            ...(categories.map((category) => ListTile(
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
              // 👇 ADDED: Long-press to delete category
              onLongPress: () async {
                // Can't delete "none" or "default" categories
                if (category.id == 'none' || category.id == 'default') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cannot delete "${category.name}" category'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                Navigator.pop(context); // Close bottom sheet first

                // Show confirmation dialog
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
                  // Move all notes from this category to "none"
                  final notesInCategory = _allNotes.where((note) => note.categoryId == category.id).toList();
                  for (var note in notesInCategory) {
                    final updatedNote = Note(
                      id: note.id,
                      title: note.title,
                      content: note.content,
                      createdAt: note.createdAt,
                      categoryId: 'none', // Move to "None" category
                    );
                    await _notesService.addNote(updatedNote);
                  }

                  // Delete the category
                  await _categoryService.deleteCategory(category.id);

                  // Refresh UI
                  setState(() {
                    _loadNotes();
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Category "${category.name}" deleted'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
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

            // Date (Newest First)
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

            // Date (Oldest First)
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

            // Title (A-Z)
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

            // Category
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
        ? _categoryService.getCategoryById(_selectedFilterCategoryId!)
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
                // Greeting
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
                  ],
                ),
                const SizedBox(height: 24),
                // Search bar
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
                // All Notes header with filter and sort
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Category filter
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

                    // Sort button
                    GestureDetector(
                      onTap: _showSortOptions,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
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
                // Notes list
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
                      final category = _categoryService.getCategoryById(note.categoryId);

                      return GestureDetector(
                        onTap: () async {
                          final updatedNote = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NoteEditorScreen(note: note),
                            ),
                          );
                          if (updatedNote != null) {
                            await _notesService.addNote(updatedNote);
                          }
                        },
                        onLongPress: () async {
                          // Show confirmation dialog
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
                            await _notesService.deleteNote(note.id);
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
                                    // Category chip
                                    if (category != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Color(category.color).withOpacity(0.2),
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
                await _notesService.addNote(newNote);
              }
            },
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}