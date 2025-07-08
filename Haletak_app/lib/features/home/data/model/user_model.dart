class User {
  final String username;
  final String mood;
  final String energy;
  final String status;
  final String profileImageUrl;

  User({
    required this.username,
    required this.mood,
    required this.energy,
    required this.status,
    required this.profileImageUrl,
  });

  // Factory constructor for creating a User instance from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? 'Guest',
      mood: json['mood'] ?? 'Neutral',
      energy: json['energy'] ?? '0%',
      status: json['status'] ?? 'Basic',
      profileImageUrl: json['profileImageUrl'] ?? '',
      // Default placeholder image
    );
  }
}
