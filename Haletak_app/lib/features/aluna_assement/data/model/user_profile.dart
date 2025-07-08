// lib/data/models/user_profile.dart
class UserProfile {
  final String? id;
  final String gender;
  final String? healthGoal;
  final DateTime? updatedAt;

  UserProfile({
    this.id,
    this.gender = '',
    this.healthGoal,
    this.updatedAt,
  });

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gender': gender,
      'healthGoal': healthGoal,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create from Firebase Map
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      gender: map['gender'] ?? '',
      healthGoal: map['healthGoal'],
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Create a copy with some fields updated
  UserProfile copyWith({
    String? id,
    String? gender,
    String? healthGoal,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      healthGoal: healthGoal ?? this.healthGoal,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
