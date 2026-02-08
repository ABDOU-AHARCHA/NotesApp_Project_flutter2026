import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/note.dart';
import '../models/note_category.dart'; // 👈 UPDATED IMPORT
import '../services/hive_notes_service.dart';
import '../services/hive_category_service.dart';

class NotesManager {
  final NotesService _localNotesService = NotesService();
  final CategoryService _localCategoryService = CategoryService();

  // --- NOTE OPERATIONS ---
  List<Note> getNotes() => _localNotesService.getNotes();

  Future<void> addNote(Note note) async {
    await _localNotesService.addNote(note);
  }

  Future<void> deleteNote(String id) async {
    await _localNotesService.deleteNote(id);
  }

  // --- CATEGORY OPERATIONS (Updated to NoteCategory) ---
  List<NoteCategory> getCategories() => _localCategoryService.getCategories(); // 👈 UPDATED TYPE

  NoteCategory? getCategoryById(String id) => _localCategoryService.getCategoryById(id); // 👈 UPDATED TYPE

  Future<void> addCategory(NoteCategory category) async { // 👈 UPDATED TYPE
    await _localCategoryService.addCategory(category);
  }

  Future<void> deleteCategory(String id) async {
    await _localCategoryService.deleteCategory(id);
  }

  Future<void> initCategories() async {
    await _localCategoryService.initializeDefaultCategories();
  }

  // --- LISTENERS ---
  ValueListenable<Box<Note>> get notesListenable => _localNotesService.listenable;

  // 👇 UPDATED TYPE to Box<NoteCategory>
  ValueListenable<Box<NoteCategory>> get categoriesListenable => _localCategoryService.listenable;
}