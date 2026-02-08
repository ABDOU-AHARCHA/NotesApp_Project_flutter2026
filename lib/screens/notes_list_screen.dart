import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/note_category.dart';
import '../services/hive_category_service.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final CategoryService _categoryService;

  String _selectedCategoryId = 'none'; // 👈 CHANGED: Default to 'none' instead of 'default'
  List<NoteCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _categoryService = CategoryService();

    // Set selected category (existing note or none)
    _selectedCategoryId = widget.note?.categoryId ?? 'none'; // 👈 CHANGED

    // Load categories
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      _categories = _categoryService.getCategories();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
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

  // Show category selector bottom sheet
  void _showCategorySelector() {
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
              'Select Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // List of categories
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
            // Create new category button
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
                _showCreateCategoryDialog();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Show create new category dialog
  void _showCreateCategoryDialog() {
    final nameController = TextEditingController();
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('New Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Category name',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              const Text('Choose Color:', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              // Color picker (simple)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Colors.blue,
                  Colors.red,
                  Colors.green,
                  Colors.orange,
                  Colors.purple,
                  Colors.pink,
                  Colors.teal,
                  Colors.amber,
                ].map((color) => GestureDetector(
                  onTap: () {
                    setDialogState(() {
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isNotEmpty) {
                  final newCategory = NoteCategory(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    color: selectedColor.value,
                  );
                  await _categoryService.addCategory(newCategory);
                  _loadCategories();
                  setState(() {
                    _selectedCategoryId = newCategory.id;
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B68AA),
              ),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = _categoryService.getCategoryById(_selectedCategoryId);

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
                        onPressed: () {
                          Navigator.pop(context);
                        }),
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
                            categoryId: _selectedCategoryId, // Save category
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
                    )
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
                        // Category chip (clickable to change)
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
                                  selectedCategory?.name ?? 'None', // 👈 CHANGED: Shows "None" instead of "Personal"
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