import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/screens/splash_screen.dart';
import 'models/note.dart';
import 'models/note_category.dart';
import 'services/hive_category_service.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/signup_screen.dart';
import 'screens/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('🚀 APP - Starting Firebase initialization');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('✅ APP - Firebase initialized');

  // Initialize Hive
  await Hive.initFlutter();
  print('✅ APP - Hive initialized');

  // Register adapters
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(NoteCategoryAdapter());

  // Open boxes
  await Hive.openBox<Note>('notes');
  await Hive.openBox<NoteCategory>('categories');
  print('✅ APP - Hive boxes opened');

  // Initialize default categories
  final categoryService = CategoryService();
  await categoryService.initializeDefaultCategories();
  print('✅ APP - Categories initialized');

  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('🏗️ APP - Building NotesApp');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}