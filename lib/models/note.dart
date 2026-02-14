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

  @HiveField(4)
  final String categoryId; // Links to Category.id

  @HiveField(5) // NEW FIELD
  final String? userId; // null for guest, UID for logged-in user

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.categoryId = 'default', // Default category
    this.userId,
  });

  // 🔹 For Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'categoryId': categoryId,
      'userId': userId,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      categoryId: map['categoryId'],
      userId: map['userId'],
    );
  }

  // 🔹 Optional helper to copy with new fields
  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    String? categoryId,
    String? userId,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      categoryId: categoryId ?? this.categoryId,
      userId: userId ?? this.userId,
    );
  }
}
