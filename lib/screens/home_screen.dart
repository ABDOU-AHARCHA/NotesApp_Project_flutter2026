import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';
import '../services/notes_service.dart';
import 'notes_list_screen.dart';

class NotesHomeScreen extends StatefulWidget {
  const NotesHomeScreen({super.key});

  @override
  State<NotesHomeScreen> createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  late final NotesService _notesService;
  late Box<Note> _notesBox;

  @override
  void initState() {
    super.initState();
    _notesService = NotesService();
    _notesBox = Hive.box<Note>('notes');
    _notesBox.listenable().addListener(() {
      setState(() {});
    });
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
    final notes = _notesService.getNotes();

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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.black54, size: 24),
                      SizedBox(width: 12),
                      Text('Search note',
                          style: TextStyle(fontSize: 16, color: Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // All Notes header
                Row(
                  children: const [
                    Text('All Notes',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_drop_down, color: Colors.black, size: 28),
                  ],
                ),
                const SizedBox(height: 16),
                // Notes list
                Expanded(
                  child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];

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
                          await _notesService.deleteNote(note.id);
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
                                Text(note.title,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                                const SizedBox(height: 4),
                                Text(note.content,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black54)),
                                const SizedBox(height: 4),
                                Text(
                                    '${_monthName(note.createdAt.month)} ${note.createdAt.day} | Passport',
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
