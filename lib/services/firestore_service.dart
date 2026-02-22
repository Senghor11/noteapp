import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get reference to current user's notes collection
  CollectionReference<Map<String, dynamic>> _getUserNotesRef() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');
    return _db.collection('users').doc(userId).collection('notes');
  }

  // Stream notes for current user (real-time updates)
  Stream<List<Note>> getNotes() {
    try {
      return _getUserNotesRef()
          .orderBy('dateModified', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => Note.fromFirestore(doc))
                .toList();
          });
    } catch (e) {
      print('Error getting notes: $e');
      return Stream.value([]);
    }
  }

  // Add a new note
  Future<void> addNote(Note note) async {
    try {
      await _getUserNotesRef().add({
        'title': note.title,
        'content': note.content,
        'contentJson': note.contentJson,
        'dateCreated': note.dateCreated,
        'dateModified': note.dateModified,
        'tags': note.tags ?? [],
      });
    } catch (e) {
      print('Error adding note: $e');
      rethrow;
    }
  }

  // Update an existing note
  Future<void> updateNote(Note note) async {
    try {
      if (note.id == null) throw Exception('Note ID is required for update');
      
      await _getUserNotesRef().doc(note.id).update({
        'title': note.title,
        'content': note.content,
        'contentJson': note.contentJson,
        'dateModified': note.dateModified,
        'tags': note.tags ?? [],
      });
    } catch (e) {
      print('Error updating note: $e');
      rethrow;
    }
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    try {
      await _getUserNotesRef().doc(noteId).delete();
    } catch (e) {
      print('Error deleting note: $e');
      rethrow;
    }
  }
}