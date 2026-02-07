import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4) // NEW FIELD
  final String categoryId; // Links to Category.id

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.categoryId = 'default', // Default category
  });
}