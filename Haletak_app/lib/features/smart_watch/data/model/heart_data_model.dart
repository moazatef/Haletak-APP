class HeartData {
  final int bpm;
  final DateTime timestamp;

  HeartData({required this.bpm, required this.timestamp});

  factory HeartData.fromMap(Map<String, dynamic> data) {
    return HeartData(
      bpm: data['bpm'] ?? 0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp'] ?? 0),
    );
  }
}
