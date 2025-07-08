import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/model/camera_model.dart';
import '../../data/service/camera_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image;
  String? _captureDate;
  EmotionModel? _emotionData;
  bool _isLoading = false;

  // Method to take a photo
  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _captureDate =
            DateFormat('MMMM dd, yyyy - hh:mm a').format(DateTime.now());
        _emotionData = null; // Reset emotion data when a new image is taken
        _isLoading = true; // Set loading state
      });

      await _sendImageToBackend();
    }
  }

  // Method to send image to the backend API
  Future<void> _sendImageToBackend() async {
    if (_image == null) return;

    try {
      final emotionData = await ApiService().uploadImage(_image!);
      setState(() {
        _emotionData = emotionData; // Set the emotion data after response
        _isLoading = false; // Clear loading state
      });
    } catch (e) {
      print("Error while fetching emotion data: $e");
      setState(() {
        _emotionData = null; // Set null if an error occurred
        _isLoading = false; // Clear loading state
      });

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error analyzing image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Helper method to get a more readable format for emotion scores
  String _formatScore(double score) {
    return '${score.toStringAsFixed(1)}%';
  }

  // Helper method to get color based on emotion
  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return Colors.yellow.shade700;
      case 'sad':
        return Colors.blue.shade700;
      case 'angry':
        return Colors.red.shade700;
      case 'fear':
        return Colors.purple.shade700;
      case 'disgust':
        return Colors.green.shade700;
      case 'surprise':
        return Colors.orange.shade700;
      case 'neutral':
        return Colors.grey.shade700;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emotion Detection',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF54B6AB),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF54B6AB), Color.fromARGB(255, 255, 255, 255)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(color: Colors.white.withOpacity(0.1)),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Display selected image or prompt to take a photo
                    if (_image != null)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Image.file(
                              _image!,
                              width: 250,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _captureDate ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF54B6AB),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 80,
                              color: Colors.white,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Take a photo to detect emotions',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 40),

                    // Button to capture photo
                    ElevatedButton(
                      onPressed: _takePhoto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.camera_alt, color: Color(0xFF54B6AB)),
                          SizedBox(width: 10),
                          Text(
                            'Take Photo',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF54B6AB),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Show emotion data after receiving from backend
                    if (_emotionData != null)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Dominant Emotion: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _emotionData!.dominantEmotion.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: _getEmotionColor(
                                      _emotionData!.dominantEmotion,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Emotion Scores:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildEmotionProgressBar(
                              'Happy',
                              _emotionData!.emotionScores.happy,
                              Colors.yellow.shade700,
                            ),
                            _buildEmotionProgressBar(
                              'Sad',
                              _emotionData!.emotionScores.sad,
                              Colors.blue.shade700,
                            ),
                            _buildEmotionProgressBar(
                              'Angry',
                              _emotionData!.emotionScores.angry,
                              Colors.red.shade700,
                            ),
                            _buildEmotionProgressBar(
                              'Fear',
                              _emotionData!.emotionScores.fear,
                              Colors.purple.shade700,
                            ),
                            _buildEmotionProgressBar(
                              'Disgust',
                              _emotionData!.emotionScores.disgust,
                              Colors.green.shade700,
                            ),
                            _buildEmotionProgressBar(
                              'Surprise',
                              _emotionData!.emotionScores.surprise,
                              Colors.orange.shade700,
                            ),
                            _buildEmotionProgressBar(
                              'Neutral',
                              _emotionData!.emotionScores.neutral,
                              Colors.grey.shade700,
                            ),
                          ],
                        ),
                      ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Analyzing emotions...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionProgressBar(String label, double value, Color color) {
    // Clamp value between 0 and 100
    double clampedValue = value.clamp(0.0, 100.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: clampedValue / 100,
                backgroundColor: Colors.grey.shade200,
                color: color,
                minHeight: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            _formatScore(clampedValue),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
