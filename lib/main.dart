import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/note.dart';
import 'models/note_category.dart';
import 'services/hive_category_service.dart';
import 'theme/app_theme.dart';
import 'firebase_options.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(NoteCategoryAdapter());
  await Hive.openBox<Note>('notes');
  await Hive.openBox<NoteCategory>('categories');

  final categoryService = CategoryService();
  await categoryService.initializeDefaultCategories();

  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}