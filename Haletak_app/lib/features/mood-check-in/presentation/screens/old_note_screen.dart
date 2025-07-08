// ignore_for_file: use_build_context_synchronously

import 'package:aluna/core/theme/colors.dart';
import 'package:aluna/features/mood-check-in/data/service/ml_service.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../../logic/note_controller.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _textController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  final NoteController _noteController =
      NoteController(); // ✅ Removed Firebase dependency
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  // ✅ Request microphone permissions
  Future<void> _requestPermissions() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      _initSpeech();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Microphone permission is required for voice recording'),
        ),
      );
    }
  }

  // ✅ Initialize speech recognition
  Future<void> _initSpeech() async {
    _speechEnabled = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done') {
          setState(() {
            _isListening = false;
          });
        }
      },
      onError: (errorNotification) {
        setState(() {
          _isListening = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Speech recognition error: ${errorNotification.errorMsg}'),
          ),
        );
      },
    );
    setState(() {});
  }

  // ✅ Start listening
  void _startListening() async {
    if (!_speechEnabled) {
      await _initSpeech();
    }

    if (_speechEnabled) {
      setState(() {
        _isListening = true;
      });

      try {
        await _speech.listen(
          onResult: (result) {
            setState(() {
              if (result.finalResult) {
                _textController.text += " ${result.recognizedWords}";
              }
            });
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 5),
          localeId: 'en_US',
        );
      } catch (e) {
        setState(() {
          _isListening = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition not available')),
      );
    }
  }

  // ✅ Stop listening
  void _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _saveNote() async {
    if (_textController.text.trim().isNotEmpty) {
      try {
        final mlService = MLService();
        String moodStatus = await mlService
            .analyzeMood(_textController.text); // ✅ Get mood from Flask API

        await _noteController.addNote(
          _textController.text,
          DateTime.now(),
          moodStatus, // ✅ Save predicted mood
        );

        // ✅ Show the result using a dialog
        _showMoodResultDialog(moodStatus);
      } catch (e) {
        print("Error saving note: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save note')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text')),
      );
    }
  }

// ✅ Function to show mood result in a dialog
  void _showMoodResultDialog(String moodStatus) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Mood Prediction"),
          content: Text("Your mood: $moodStatus"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Your Note',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Any thing you want to add',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your notes on any thought that reflecting your mood',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        'How wonderful it is to be with yourself sometimes!',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _isListening ? _stopListening : _startListening,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isListening ? Icons.stop : Icons.mic,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isListening ? 'Stop recording' : 'Record voice note',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorStyles.mainColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: ColorStyles.fontButtonColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: _saveNote,
              child: const Text(
                'Skip and Save',
                style: TextStyle(
                  color: ColorStyles.mainColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _speech.cancel();
    super.dispose();
  }
}
