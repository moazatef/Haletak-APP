class MessageModel {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;
  final String? apiId; // ID from the API response
  final bool isSent; // Track if message was successfully sent
  final bool isDelivered; // Track delivery status

  MessageModel({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.type = MessageType.text,
    this.apiId,
    this.isSent = true,
    this.isDelivered = true,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      content: json['content'] ?? json['text'] ?? '',
      isUser: json['isUser'] ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      apiId: json['apiId']?.toString(),
      isSent: json['isSent'] ?? true,
      isDelivered: json['isDelivered'] ?? true,
    );
  }

  // Factory constructor for API response
  factory MessageModel.fromApiResponse(Map<String, dynamic> json) {
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: json['response'] ?? json['text'] ?? 'No response',
      isUser: false,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      type: MessageType.text,
      apiId: json['id']?.toString(),
      isSent: true,
      isDelivered: true,
    );
  }

  // Create user message for sending
  factory MessageModel.userMessage({
    required String content,
    String? customId,
  }) {
    return MessageModel(
      id: customId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
      type: MessageType.text,
      isSent: false, // Will be updated after successful API call
      isDelivered: false,
    );
  }

  // Create bot message
  factory MessageModel.botMessage({
    required String content,
    String? apiId,
  }) {
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
      type: MessageType.text,
      apiId: apiId,
      isSent: true,
      isDelivered: true,
    );
  }

  // Create suggestion message
  factory MessageModel.suggestion({
    required String content,
  }) {
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
      type: MessageType.suggestion,
      isSent: true,
      isDelivered: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'apiId': apiId,
      'isSent': isSent,
      'isDelivered': isDelivered,
    };
  }

  // Convert to API request format
  Map<String, dynamic> toApiRequest({required int userId}) {
    return {
      'text': content,
      'users': userId,
    };
  }

  // Copy with method for updating message status
  MessageModel copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    MessageType? type,
    String? apiId,
    bool? isSent,
    bool? isDelivered,
  }) {
    return MessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      apiId: apiId ?? this.apiId,
      isSent: isSent ?? this.isSent,
      isDelivered: isDelivered ?? this.isDelivered,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MessageModel(id: $id, content: $content, isUser: $isUser, timestamp: $timestamp, type: $type)';
  }
}

enum MessageType {
  text,
  suggestion,
  emotion,
  system, // For system messages like "typing..."
  error, // For error messages
  welcome // For welcome messages
}
