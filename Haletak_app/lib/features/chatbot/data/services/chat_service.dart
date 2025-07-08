import 'dart:async';
import 'dart:convert';

import 'package:aluna/features/chatbot/data/model/message_model.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static const String _baseUrl = 'https://web-production-f73d.up.railway.app';
  final List<MessageModel> _messages = [];
  final StreamController<List<MessageModel>> _messagesController =
      StreamController<List<MessageModel>>.broadcast();

  Stream<List<MessageModel>> get messagesStream => _messagesController.stream;
  List<MessageModel> get messages => List.unmodifiable(_messages);

  ChatService() {
    _initializeWelcomeMessage();
  }

  void _initializeWelcomeMessage() {
    final welcomeMessage = MessageModel(
      id: '1',
      content: 'مرحباً! أنا هنا لدعمك. كيف تشعر اليوم؟',
      isUser: false,
      timestamp: DateTime.now(),
    );

    _messages.add(welcomeMessage);
    _messagesController.add(_messages);
  }

  Future<void> sendMessage(String content) async {
    final userMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    _messagesController.add(_messages);

    try {
      final response = await _sendMessageToAPI(content);
      final botResponse = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
      );

      _messages.add(botResponse);
      _messagesController.add(_messages);
    } catch (e) {
      // Handle error with fallback message
      final errorMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'عذراً، حدث خطأ في الاتصال. يرجى المحاولة مرة أخرى.',
        isUser: false,
        timestamp: DateTime.now(),
      );

      _messages.add(errorMessage);
      _messagesController.add(_messages);
    }
  }

  Future<String> _sendMessageToAPI(String message) async {
    final url = Uri.parse('$_baseUrl/chat');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['response'] ??
          'لم أتمكن من فهم الرسالة. يرجى المحاولة مرة أخرى.';
    } else {
      throw Exception('Failed to send message: ${response.statusCode}');
    }
  }

  List<String> getSuggestions() {
    return [
      "أشعر بالتوتر",
      "مساعدة في القلق",
      "أشعر بالاكتئاب",
      "مشاكل في النوم",
      "مشاكل في العلاقات",
      "ضغط العمل",
    ];
  }

  void dispose() {
    _messagesController.close();
  }
}
