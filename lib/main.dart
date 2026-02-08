import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/note.dart';
import 'models/note_category.dart';
import 'services/hive_category_service.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(NoteCategoryAdapter());

  // Open boxes
  await Hive.openBox<Note>('notes');
  await Hive.openBox<NoteCategory>('categories');

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
      theme: AppTheme.lightTheme,
      home: const NotesHomeScreen(),
    );
  }
}