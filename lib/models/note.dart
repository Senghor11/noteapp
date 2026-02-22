// lib/models/note.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  Note({
    this.id, // Firestore document ID
    required this.title,
    required this.content,
    required this.contentJson,
    required this.dateCreated,
    required this.dateModified,
    required this.tags,
  });

  final String? id; // Add this for Firestore document ID
  final String? title;
  final String? content;
  final String contentJson;
  final int dateCreated;
  final int dateModified;
  final List<String>? tags;

  // Convert to map for Firestore (when adding/updating)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'contentJson': contentJson,
      'dateCreated': dateCreated,
      'dateModified': dateModified,
      'tags': tags ?? [],
    };
  }

  // Create a Note from Firestore document
  factory Note.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Note(
      id: doc.id,
      title: data['title'],
      content: data['content'],
      contentJson: data['contentJson'],
      dateCreated: data['dateCreated'],
      dateModified: data['dateModified'],
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  // For debugging
  @override
  String toString() {
    return 'Note(id: $id, title: $title, dateModified: $dateModified)';
  }
}