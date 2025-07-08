class UserModel {
  final String? id;
  final String? gender;
  final int? age;

  UserModel({
    this.id,
    this.gender,
    this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gender': gender,
      'age': age,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      gender: json['gender'],
      age: json['age'],
    );
  }
}
