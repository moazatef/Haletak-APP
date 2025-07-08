import 'package:cloud_firestore/cloud_firestore.dart';

class MoodEntry {
  final String id;
  final int moodScore; // 1-5 rating
  final DateTime timestamp;
  final List<String> reasonIds;
  final String? notes;

  MoodEntry({
    required this.id,
    required this.moodScore,
    required this.timestamp,
    required this.reasonIds,
    this.notes,
  });

  factory MoodEntry.fromMap(Map<String, dynamic> map, String docId) {
    return MoodEntry(
      id: docId,
      moodScore: map['moodScore'] ?? 3,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      reasonIds: List<String>.from(map['reasonIds'] ?? []),
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'moodScore': moodScore,
      'timestamp': Timestamp.fromDate(timestamp),
      'reasonIds': reasonIds,
      'notes': notes,
    };
  }
}
