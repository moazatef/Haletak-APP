// lib/data/repositories/note_repository.dart

import 'package:aluna/features/note-list/models/model/note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user ID, or create an anonymous ID if not logged in
  Future<String> get _userId async {
    if (_auth.currentUser == null) {
      // Create anonymous user if not logged in
      final userCredential = await _auth.signInAnonymously();
      return userCredential.user!.uid;
    }
    return _auth.currentUser!.uid;
  }

  Stream<List<Note>> getNotes() async* {
    final uid = await _userId;

    yield* _firestore
        .collection('users')
        .doc(uid)
        .collection('notes')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> addNote(Note note) async {
    final uid = await _userId;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('notes')
        .add(note.toMap());
  }

  Future<void> updateNote(Note note) async {
    final uid = await _userId;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('notes')
        .doc(note.id)
        .update(note.toMap());
  }

  Future<void> deleteNote(String noteId) async {
    final uid = await _userId;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('notes')
        .doc(noteId)
        .delete();
  }
}
