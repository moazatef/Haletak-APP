// lib/data/models/user_model.dart
class UserModel {
  final String? id;
  final String? gender;
  final int? age;
  final int? weightKg;
  // Add other fields as needed

  UserModel({
    this.id,
    this.gender,
    this.age,
    this.weightKg,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gender': gender,
      'age': age,
      'weightKg': weightKg,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      gender: json['gender'],
      age: json['age'],
      weightKg: json['weightKg'],
    );
  }
}
