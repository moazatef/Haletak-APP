import 'package:flutter/material.dart';
import 'package:aluna/features/mood-check-in/logic/note_controller.dart';
import 'package:aluna/features/mood-check-in/data/model/note_model.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final NoteController _noteController = NoteController(); // ✅ No Firebase

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Notes")),
      body: FutureBuilder<List<NoteModel>>(
        future: _noteController.getNotes(), // ✅ Fetch notes from local storage
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No notes found"));
          }

          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.content),
                subtitle: Text("Mood: ${note.moodStatus}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await _noteController
                        .deleteNote(note.id); // ✅ Delete from local storage
                    setState(() {}); // Refresh UI
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
