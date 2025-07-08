import 'dart:convert';
import 'package:http/http.dart' as http;

class MLService {
  final String flaskApiUrl =
      "http://192.168.1.12:5000/predict"; // Update with actual Flask URL

  Future<String> analyzeMood(String text) async {
    try {
      final response = await http.post(
        Uri.parse(flaskApiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["mood"];
      } else {
        return "Error: ${response.body}";
      }
    } catch (e) {
      print("❌ API Error: $e");
      return "Unknown"; // Default if API fails
    }
  }
}
