import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:aluna/features/mood-check-in/data/model/note_model.dart';

class NoteController {
  Future<void> addNote(
      String content, DateTime timestamp, String moodStatus) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notes = prefs.getStringList('notes') ?? [];

    NoteModel newNote = NoteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      timestamp: timestamp,
      moodStatus: moodStatus,
    );

    notes.add(jsonEncode(newNote.toMap()));
    await prefs.setStringList('notes', notes);
  }

  Future<List<NoteModel>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notes = prefs.getStringList('notes') ?? [];
    return notes
        .map((note) => NoteModel.fromMap(jsonDecode(note), ""))
        .toList();
  }

  Future<void> deleteNote(String noteId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notes = prefs.getStringList('notes') ?? [];

    notes.removeWhere((note) {
      final decodedNote = jsonDecode(note);
      return decodedNote['id'] == noteId;
    });

    await prefs.setStringList('notes', notes);
  }
}
