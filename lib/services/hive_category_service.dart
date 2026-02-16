import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note_category.dart';
import 'package:hive/hive.dart';

class CategoryService {
  final Box<NoteCategory> _categoryBox = Hive.box<NoteCategory>('categories');

  // =========================================================
  // DEFAULT CATEGORIES (exposed for cloud init)
  // =========================================================

  List<NoteCategory> getDefaultCategories() {
    return [
      NoteCategory(id: 'none', name: 'None', color: Colors.grey.value),
      NoteCategory(id: 'default', name: 'Personal', color: Colors.blue.value),
      NoteCategory(id: 'work', name: 'Work', color: Colors.orange.value),
      NoteCategory(id: 'ideas', name: 'Ideas', color: Colors.purple.value),
    ];
  }

  Future<void> initializeDefaultCategories() async {
    if (_categoryBox.isEmpty) {
      for (final category in getDefaultCategories()) {
        await addCategory(category);
      }
    }
  }

  // =========================================================
  // CRUD
  // =========================================================

  List<NoteCategory> getCategories() {
    return _categoryBox.values.toList();
  }

  NoteCategory? getCategoryById(String id) {
    return _categoryBox.get(id);
  }

  Future<void> addCategory(NoteCategory category) async {
    await _categoryBox.put(category.id, category);
  }

  Future<void> deleteCategory(String id) async {
    if (id != 'default' && id != 'none') {
      await _categoryBox.delete(id);
    }
  }

  ValueListenable<Box<NoteCategory>> get listenable => _categoryBox.listenable();
}