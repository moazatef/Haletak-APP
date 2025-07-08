// lib/data/model/sleep_quality.dart
class SleepQuality {
  final String rating;
  final String hoursRange;
  final int hours;

  SleepQuality({
    required this.rating,
    required this.hoursRange,
    required this.hours,
  });

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'hoursRange': hoursRange,
      'hours': hours,
    };
  }

  factory SleepQuality.fromMap(Map<String, dynamic> map) {
    return SleepQuality(
      rating: map['rating'] ?? '',
      hoursRange: map['hoursRange'] ?? '',
      hours: map['hours'] ?? 0,
    );
  }
}
