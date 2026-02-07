import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1) // Different from Note (typeId: 0)
class Category {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int color; // Store color as int (Color.value)

  Category({
    required this.id,
    required this.name,
    required this.color,
  });
}