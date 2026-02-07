import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/category.dart';

class CategoryService {
  final Box<Category> _categoryBox = Hive.box<Category>('categories');

  // Initialize default categories if box is empty
  Future<void> initializeDefaultCategories() async {
    if (_categoryBox.isEmpty) {
      // 👇 ADDED: "None" category for notes without category
      await addCategory(Category(
        id: 'none',
        name: 'None',
        color: Colors.grey.value,
      ));
      await addCategory(Category(
        id: 'default',
        name: 'Personal',
        color: Colors.blue.value,
      ));
      await addCategory(Category(
        id: 'work',
        name: 'Work',
        color: Colors.orange.value,
      ));
      await addCategory(Category(
        id: 'ideas',
        name: 'Ideas',
        color: Colors.purple.value,
      ));
    }
  }

  List<Category> getCategories() {
    return _categoryBox.values.toList();
  }

  Category? getCategoryById(String id) {
    return _categoryBox.get(id);
  }

  Future<void> addCategory(Category category) async {
    await _categoryBox.put(category.id, category);
  }

  // 👇 UPDATED: Can't delete "none" or "default" categories
  Future<void> deleteCategory(String id) async {
    // Don't delete protected categories
    if (id != 'default' && id != 'none') {
      await _categoryBox.delete(id);
    }
  }
}