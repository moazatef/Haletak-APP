// lib/data/models/note_model.dart

class Note {
  final String id;
  final String mood;
  final String moodScore;
  final String feeling;
  final String reason;
  final String note;
  final String timestamp;
  final String? tip;

  Note({
    required this.id,
    required this.mood,
    required this.moodScore,
    required this.feeling,
    required this.reason,
    required this.note,
    required this.timestamp,
    this.tip,
  });

  factory Note.fromMap(Map<String, dynamic> map, String id) {
    return Note(
      id: id,
      mood: map['mood'] ?? '',
      moodScore: map['moodScore'] ?? '',
      feeling: map['feeling'] ?? '',
      reason: map['reason'] ?? '',
      note: map['note'] ?? '',
      timestamp: map['timestamp'] ?? '',
      tip: map['tip'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mood': mood,
      'moodScore': moodScore,
      'feeling': feeling,
      'reason': reason,
      'note': note,
      'timestamp': timestamp,
      'tip': tip,
    };
  }
}
