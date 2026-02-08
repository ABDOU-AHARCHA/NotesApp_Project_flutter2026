import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class NoteCategory {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int color; // Store color as int (Color.value)

  NoteCategory({
    required this.id,
    required this.name,
    required this.color,
  });
}