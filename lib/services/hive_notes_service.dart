import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Add this import for .listenable()
import '../models/note.dart';
import 'package:flutter/foundation.dart';

class NotesService {
  final Box<Note> _notesBox = Hive.box<Note>('notes');

  List<Note> getNotes() {
    return _notesBox.values.toList();
  }

  Future<void> addNote(Note note) async {
    await _notesBox.put(note.id, note);
  }

  Future<void> deleteNote(String id) async {
    await _notesBox.delete(id);
  }

  // 👇 ADD THIS: Expose the listener for the UI
  ValueListenable<Box<Note>> get listenable => _notesBox.listenable();
}