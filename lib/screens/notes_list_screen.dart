import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/note_category.dart';
import '../services/notes_manager.dart';
import 'dart:async';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final NotesManager _notesManager;

  String _selectedCategoryId = 'none';
  List<NoteCategory> _categories = [];

  StreamSubscription<List<NoteCategory>>? _categoriesSubscription;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _notesManager = NotesManager();

    _selectedCategoryId = widget.note?.categoryId ?? 'none';

    _categoriesSubscription = _notesManager.getCategoriesStream().listen((categories) {
      setState(() {
        _categories = categories;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoriesSubscription?.cancel();
    _notesManager.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final noteDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'pm' : 'am';
    final time = '${hour == 0 ? 12 : hour}:$minute $period';

    if (noteDate == today) {
      return 'Today $time';
    } else if (noteDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday $time';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[dateTime.month - 1]} ${dateTime.day} $time';
    }
  }

  void _showCategorySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) {
        final double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.only(bottom: bottomPadding),
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
                'Select Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
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
                trailing: _selectedCategoryId == category.id
                    ? const Icon(Icons.check, color: Color(0xFF7B68AA))
                    : null,
                onTap: () {
                  setState(() {
                    _selectedCategoryId = category.id;
                  });
                  Navigator.pop(context);
                },
              ))),
              const Divider(),
              ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 16, color: Colors.black54),
                ),
                title: const Text(
                  'Create New Category',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showCreateCategorySheet(); // ✅ now opens bottom sheet
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // ✅ NEW: Create category as bottom sheet instead of dialog
  void _showCreateCategorySheet() {
    final nameController = TextEditingController();
    Color selectedColor = Colors.blue;

    final List<Color> colorOptions = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.amber,
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
     // ✅ above system UI
      isScrollControlled: true, // ✅ sheet rises with keyboard
      builder: (context) {
        final double bottomPadding = MediaQuery.of(context).viewPadding.bottom; // ✅ nav bar fix
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              // ✅ rises above keyboard when it opens
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: 24 + bottomPadding, // ✅ nav bar fix
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'New Category',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    // Name field
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Category name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Choose Color:',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    // Color picker
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: colorOptions.map((color) => GestureDetector(
                        onTap: () {
                          setSheetState(() {
                            selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColor == color
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                    // Buttons row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Colors.black, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (nameController.text.trim().isNotEmpty) {
                                final newCategory = NoteCategory(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  name: nameController.text.trim(),
                                  color: selectedColor.value,
                                );
                                await _notesManager.addCategory(newCategory);
                                setState(() {
                                  _selectedCategoryId = newCategory.id;
                                });
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: const Color(0xFF8884FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'Create',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = _notesManager.getCategoryById(_selectedCategoryId);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8C5E8), Color(0xFFD4A5D4)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context)),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.black),
                      onPressed: () {
                        if (_titleController.text.trim().isNotEmpty &&
                            _contentController.text.trim().isNotEmpty) {
                          final newNote = Note(
                            id: widget.note?.id ??
                                DateTime.now().millisecondsSinceEpoch.toString(),
                            title: _titleController.text.trim(),
                            content: _contentController.text.trim(),
                            createdAt: widget.note?.createdAt ?? DateTime.now(),
                            categoryId: _selectedCategoryId,
                            userId: widget.note?.userId,
                          );
                          Navigator.pop(context, newNote);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter both title and content'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              // Title & timestamp
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Title',
                          hintStyle: TextStyle(color: Colors.black38),
                          isDense: true,
                          contentPadding: EdgeInsets.zero),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _formatDateTime(widget.note?.createdAt ?? DateTime.now()),
                          style: const TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        const SizedBox(width: 8),
                        const Text('|', style: TextStyle(color: Colors.black38)),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _showCategorySelector,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: selectedCategory != null
                                  ? Color(selectedCategory.color).withOpacity(0.2)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedCategory != null
                                    ? Color(selectedCategory.color)
                                    : Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  selectedCategory?.name ?? 'None',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: selectedCategory != null
                                        ? Color(selectedCategory.color)
                                        : Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 16,
                                  color: selectedCategory != null
                                      ? Color(selectedCategory.color)
                                      : Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Start typing...',
                        hintStyle: TextStyle(color: Colors.black38)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}