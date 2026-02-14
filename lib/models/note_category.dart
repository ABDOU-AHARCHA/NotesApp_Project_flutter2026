import 'package:hive/hive.dart';

part 'note_category.g.dart';

@HiveType(typeId: 1)
class NoteCategory extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int color;

  @HiveField(3)
  final String? userId; // For cloud sync

  NoteCategory({
    required this.id,
    required this.name,
    required this.color,
    this.userId,
  });

  // CopyWith method for easy updates
  NoteCategory copyWith({
    String? id,
    String? name,
    int? color,
    String? userId,
  }) {
    return NoteCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      userId: userId ?? this.userId,
    );
  }

  // Firestore serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'userId': userId,
    };
  }

  // Firestore deserialization
  factory NoteCategory.fromMap(Map<String, dynamic> map) {
    return NoteCategory(
      id: map['id'] as String,
      name: map['name'] as String,
      color: map['color'] as int,
      userId: map['userId'] as String?,
    );
  }
}
