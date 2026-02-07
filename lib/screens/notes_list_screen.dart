import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.note?.title ?? 'Title');
    _contentController =
        TextEditingController(text: widget.note?.content ?? 'I Would like to...');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
                        if (_titleController.text.isNotEmpty &&
                            _contentController.text.isNotEmpty) {
                          final newNote = Note(
                            id: widget.note?.id ??
                                DateTime.now().millisecondsSinceEpoch.toString(),
                            title: _titleController.text,
                            content: _contentController.text,
                            createdAt: DateTime.now(),
                          );
                          Navigator.pop(context, newNote);
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
                          border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Today 6:45 pm',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
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
