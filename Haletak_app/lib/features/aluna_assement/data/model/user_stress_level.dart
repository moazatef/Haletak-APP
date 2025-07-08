class StressLevel {
  final int level;
  final DateTime timestamp;

  StressLevel({required this.level, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
