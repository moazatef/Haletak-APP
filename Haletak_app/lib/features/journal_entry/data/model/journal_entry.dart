class Journal {
  final int? id;
  final String title;
  final String text;
  final int? userId;
  final int? stressLevel;
  final String? emotion;
  final String? stressor;
  final DateTime createdAt;
  final MlResponse? mlResponse;

  Journal({
    this.id,
    required this.title,
    required this.text,
    this.userId,
    this.stressLevel = 3,
    this.emotion = 'Neutral',
    this.stressor = 'Loneliness',
    DateTime? createdAt,
    this.mlResponse,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Journal.fromJson(Map<String, dynamic> json) {
    return Journal(
      id: json['id'],
      title: json['title'] ?? '',
      text: json['text'] ?? '',
      userId: json['users_id'] ?? json['user_id'], // Handle both cases
      stressLevel: json['stress_level'] ?? 3,
      emotion: json['emotion'] ?? 'Neutral',
      stressor: json['stressor'] ?? 'Loneliness',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      mlResponse: json['ml_response'] != null
          ? MlResponse.fromJson(json['ml_response'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'user_id': userId,
      'stress_level': stressLevel,
      'emotion': emotion,
      'stressor': stressor,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Journal copyWith({
    int? id,
    String? title,
    String? text,
    int? userId,
    int? stressLevel,
    String? emotion,
    String? stressor,
    DateTime? createdAt,
  }) {
    return Journal(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      userId: userId ?? this.userId,
      stressLevel: stressLevel ?? this.stressLevel,
      emotion: emotion ?? this.emotion,
      stressor: stressor ?? this.stressor,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  map(Journal Function(dynamic item) param0) {}
}

class MlResponse {
  final String predictedMood;
  final double confidence;
  final List<MoodPrediction> topPredictions;

  MlResponse({
    required this.predictedMood,
    required this.confidence,
    required this.topPredictions,
  });

  factory MlResponse.fromJson(Map<String, dynamic> json) {
    return MlResponse(
      predictedMood: json['predicted_mood'],
      confidence: json['confidence']?.toDouble() ?? 0.0,
      topPredictions: [], // The API doesn't seem to provide this
    );
  }
}

class MoodPrediction {
  final String mood;
  final double confidence;

  MoodPrediction({
    required this.mood,
    required this.confidence,
  });

  factory MoodPrediction.fromJson(Map<String, dynamic> json) {
    return MoodPrediction(
      mood: json['mood'],
      confidence: json['confidence']?.toDouble() ?? 0.0,
    );
  }
}
