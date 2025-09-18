import 'dart:convert';

class ContentItem {
  final String id;
  final String title;
  final String description;
  final String targetModule; // e.g., 'home', 'events', 'media', 'giving', 'about'
  final String? imagePath; // local path in app documents
  final DateTime createdAt;

  ContentItem({
    required this.id,
    required this.title,
    required this.description,
    required this.targetModule,
    this.imagePath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  ContentItem copyWith({
    String? imagePath,
    String? title,
    String? description,
  }) {
    return ContentItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetModule: targetModule,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetModule': targetModule,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ContentItem.fromMap(Map<String, dynamic> map) {
    return ContentItem(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      targetModule: map['targetModule'],
      imagePath: map['imagePath'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());
  factory ContentItem.fromJson(String source) => ContentItem.fromMap(json.decode(source));
}
