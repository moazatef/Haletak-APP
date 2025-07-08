import 'dart:convert';
import 'package:flutter/services.dart';

class TokenizerService {
  Map<String, dynamic>? _tokenizerData;
  int maxLen = 100; // Adjust based on model input length

  Future<void> loadTokenizer() async {
    String jsonString =
        await rootBundle.loadString('assets/tokenizer/tokenizer.json');
    _tokenizerData = json.decode(jsonString);
  }

  List<double> preprocessText(String text) {
    if (_tokenizerData == null) {
      throw Exception("Tokenizer not loaded yet!");
    }

    List<String> words = text.toLowerCase().split(' ');
    List<double> tokenizedInput =
        List.filled(maxLen, 0.0); // Initialize with padding

    int i = 0;
    for (String word in words) {
      if (_tokenizerData!['word_index'].containsKey(word)) {
        tokenizedInput[i] = _tokenizerData!['word_index'][word].toDouble();
        i++;
        if (i >= maxLen) break; // Stop if input reaches max length
      }
    }

    return tokenizedInput;
  }
}
