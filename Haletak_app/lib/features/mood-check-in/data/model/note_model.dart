class NoteModel {
  final String id;
  final String content;
  final DateTime timestamp;
  final String moodStatus;

  NoteModel({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.moodStatus,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map, String documentId) {
    return NoteModel(
      id: documentId,
      content: map['content'] ?? '',
      timestamp: DateTime.parse(map['timestamp']), // Convert string to DateTime
      moodStatus: map['moodStatus'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(), // Store timestamp as a string
      'moodStatus': moodStatus,
    };
  }
}
