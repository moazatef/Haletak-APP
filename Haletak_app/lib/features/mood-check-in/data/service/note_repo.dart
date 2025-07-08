import 'package:aluna/features/mood-check-in/data/model/note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  NotesRepository(this._firestore, this._auth);

  Future<void> addNote(
      String content, DateTime timestamp, String moodStatus) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notes')
            .add({
          'content': content,
          'timestamp': timestamp,
          'moodStatus': moodStatus, // Now saving mood status
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error adding note: $e');
      throw Exception('Failed to add note');
    }
  }

  Future<List<NoteModel>> getNotes() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notes')
            .orderBy('timestamp', descending: true)
            .get();

        return snapshot.docs
            .map((doc) => NoteModel.fromMap(doc.data(), doc.id))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting notes: $e');
      throw Exception('Failed to get notes');
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notes')
            .doc(id)
            .delete();
      }
    } catch (e) {
      print('Error deleting note: $e');
      throw Exception('Failed to delete note');
    }
  }

  Future<void> updateNote(String id, String content) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notes')
            .doc(id)
            .update({
          'content': content,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error updating note: $e');
      throw Exception('Failed to update note');
    }
  }
}
