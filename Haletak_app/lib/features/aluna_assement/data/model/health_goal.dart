// lib/data/models/health_goal.dart
class HealthGoal {
  final String id;
  final String goalType;
  final DateTime createdAt;

  HealthGoal({
    required this.id,
    required this.goalType,
    required this.createdAt,
  });

  // Convert to Firebase Map format
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goalType': goalType,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from Firebase Map format
  factory HealthGoal.fromMap(Map<String, dynamic> map) {
    return HealthGoal(
      id: map['id'],
      goalType: map['goalType'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
