import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/note.dart';
import 'models/category.dart';
import 'services/category_service.dart';  // FIXED - removed ../
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(CategoryAdapter());

  // Open boxes
  await Hive.openBox<Note>('notes');
  await Hive.openBox<Category>('categories');

  // Initialize default categories
  final categoryService = CategoryService();
  await categoryService.initializeDefaultCategories();

  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'SF Pro',
      ),
      home: const NotesHomeScreen(),
    );
  }
}