import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/camera_model.dart';

class ApiService {
  static const String _baseUrl =
      "https://deepface-api-main-production-29fe.up.railway.app/analyze/";

  Future<EmotionModel> uploadImage(File image) async {
    try {
      final uri = Uri.parse(_baseUrl);
      final request = http.MultipartRequest('POST', uri);

      // Open the file as multipart
      var multipartFile = await http.MultipartFile.fromPath("file", image.path);
      request.files.add(multipartFile);

      // Send the request
      var response = await request.send();

      // Check for successful response
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        Map<String, dynamic> emotionJson = json.decode(responseBody);

        return EmotionModel.fromJson(emotionJson);
      } else {
        throw Exception('Failed to load emotion data');
      }
    } catch (e) {
      throw Exception('Error sending image: $e');
    }
  }
}
