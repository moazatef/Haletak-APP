// lib/logic/note_provider.dart

import 'package:aluna/features/note-list/models/model/note_model.dart';
import 'package:aluna/features/note-list/models/repo/note_repository.dart';
import 'package:flutter/foundation.dart';

class NoteProvider extends ChangeNotifier {
  final NoteRepository _noteRepository = NoteRepository();
  final List<Note> _notes = [];
  final bool _isLoading = true;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  Stream<List<Note>> get notesStream => _noteRepository.getNotes();

  Future<void> addNote(Note note) async {
    try {
      await _noteRepository.addNote(note);
      notifyListeners();
    } catch (e) {
      print('Error adding note: $e');
      rethrow; // Allow the UI to handle the error
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await _noteRepository.updateNote(note);
      notifyListeners();
    } catch (e) {
      print('Error updating note: $e');
      rethrow;
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _noteRepository.deleteNote(noteId);
      notifyListeners();
    } catch (e) {
      print('Error deleting note: $e');
      rethrow;
    }
  }
}
