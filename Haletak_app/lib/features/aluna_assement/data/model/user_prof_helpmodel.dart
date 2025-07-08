// lib/data/models/user_model.dart
class UserModel {
  final String? id;
  final String? gender;
  final int? age;
  final int? weightKg;
  final bool? hasSoughtProfessionalHelp;
  final bool? hasPhysicalDistress; // Added field for physical distress

  UserModel({
    this.id,
    this.gender,
    this.age,
    this.weightKg,
    this.hasSoughtProfessionalHelp,
    this.hasPhysicalDistress,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gender': gender,
      'age': age,
      'weightKg': weightKg,
      'hasSoughtProfessionalHelp': hasSoughtProfessionalHelp,
      'hasPhysicalDistress': hasPhysicalDistress,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      gender: json['gender'],
      age: json['age'],
      weightKg: json['weightKg'],
      hasSoughtProfessionalHelp: json['hasSoughtProfessionalHelp'],
      hasPhysicalDistress: json['hasPhysicalDistress'],
    );
  }

  // Create a copy of this user with updated fields
  UserModel copyWith({
    String? id,
    String? gender,
    int? age,
    int? weightKg,
    bool? hasSoughtProfessionalHelp,
    bool? hasPhysicalDistress,
  }) {
    return UserModel(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      hasSoughtProfessionalHelp:
          hasSoughtProfessionalHelp ?? this.hasSoughtProfessionalHelp,
      hasPhysicalDistress: hasPhysicalDistress ?? this.hasPhysicalDistress,
    );
  }
}
