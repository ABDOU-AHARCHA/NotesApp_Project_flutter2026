import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/note.dart';
import '../models/note_category.dart';
import '../services/hive_notes_service.dart';
import '../services/hive_category_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesManager {
  final NotesService _localNotesService = NotesService();
  final CategoryService _localCategoryService = CategoryService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Helper getters
  User? get _currentUser => _auth.currentUser;
  bool get _isLoggedIn => _currentUser != null;


  List<Note> getNotes() => _localNotesService.getNotes();

  Future<void> addNote(Note note) async {
    if (_isLoggedIn) {
      final uid = _currentUser!.uid;

      final noteWithUser = note.copyWith(userId: uid);

      await _firestore
          .collection('notes')
          .doc(note.id)
          .set(noteWithUser.toMap());
    } else {
      await _localNotesService.addNote(note);
    }
  }

  Future<void> deleteNote(String id) async {
    if (_isLoggedIn) {
      await _firestore.collection('notes').doc(id).delete();
    } else {
      await _localNotesService.deleteNote(id);
    }
  }

  Future<void> updateNote(Note note) async {
    if (_isLoggedIn) {
      await _firestore
          .collection('notes')
          .doc(note.id)
          .update(note.toMap());
    } else {
      await _localNotesService.updateNote(note);
    }
  }

  // =========================================================
  // CATEGORY OPERATIONS (Local Only)
  // =========================================================

  List<NoteCategory> getCategories() =>
      _localCategoryService.getCategories();

  NoteCategory? getCategoryById(String id) =>
      _localCategoryService.getCategoryById(id);

  Future<void> addCategory(NoteCategory category) async {
    await _localCategoryService.addCategory(category);
  }

  Future<void> deleteCategory(String id) async {
    await _localCategoryService.deleteCategory(id);
  }

  Future<void> initCategories() async {
    await _localCategoryService.initializeDefaultCategories();
  }

  // =========================================================
  // LISTENERS
  // =========================================================

  ValueListenable<Box<Note>> get notesListenable =>
      _localNotesService.listenable;

  ValueListenable<Box<NoteCategory>> get categoriesListenable =>
      _localCategoryService.listenable;

  // =========================================================
  // STREAM (IMPORTANT FOR CLOUD)
  // =========================================================

  Stream<List<Note>> getNotesStream() {
    if (_isLoggedIn) {
      final uid = _currentUser!.uid;

      return _firestore
          .collection('notes')
          .where('userId', isEqualTo: uid)
      // ❌ REMOVED: .orderBy('createdAt', descending: true)
      // This required a composite Firestore index that likely doesn't exist,
      // causing Firestore to silently return empty results after reinstall.
          .snapshots()
          .handleError((error) {
        debugPrint('Firestore stream error: $error');
      })
          .map((snapshot) => snapshot.docs
          .map((doc) => Note.fromMap(doc.data()))
          .toList());
    } else {
      final controller = StreamController<List<Note>>();

      final listener = () {
        final box = _localNotesService.listenable.value;
        final sortedNotes = box.values.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        if (!controller.isClosed) {
          controller.add(sortedNotes);
        }
      };

      _localNotesService.listenable.addListener(listener);

      // Immediately trigger the listener to send the initial data
      listener();

      controller.onCancel = () {
        _localNotesService.listenable.removeListener(listener);
        controller.close();
      };

      return controller.stream;
    }
  }

  Stream<List<NoteCategory>> getCategoriesStream() {
    final controller = StreamController<List<NoteCategory>>();

    final listener = () {
      final box = _localCategoryService.listenable.value;
      final categories = box.values.toList();
      if (!controller.isClosed) {
        controller.add(categories);
      }
    };

    _localCategoryService.listenable.addListener(listener);

    // Immediately trigger the listener to send the initial data
    listener();

    controller.onCancel = () {
      _localCategoryService.listenable.removeListener(listener);
      controller.close();
    };

    return controller.stream;
  }
  
  void dispose() {
    // No-op
  }
}
