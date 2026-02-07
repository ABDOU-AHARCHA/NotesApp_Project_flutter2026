import 'package:hive/hive.dart';
import '../models/note.dart';

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
}