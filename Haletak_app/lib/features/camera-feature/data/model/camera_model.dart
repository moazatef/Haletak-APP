class EmotionScores {
  final double angry;
  final double disgust;
  final double fear;
  final double happy;
  final double sad;
  final double surprise;
  final double neutral;

  EmotionScores({
    required this.angry,
    required this.disgust,
    required this.fear,
    required this.happy,
    required this.sad,
    required this.surprise,
    required this.neutral,
  });

  factory EmotionScores.fromJson(Map<String, dynamic> json) {
    return EmotionScores(
      angry: json['angry']?.toDouble() ?? 0.0,
      disgust: json['disgust']?.toDouble() ?? 0.0,
      fear: json['fear']?.toDouble() ?? 0.0,
      happy: json['happy']?.toDouble() ?? 0.0,
      sad: json['sad']?.toDouble() ?? 0.0,
      surprise: json['surprise']?.toDouble() ?? 0.0,
      neutral: json['neutral']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'angry': angry,
      'disgust': disgust,
      'fear': fear,
      'happy': happy,
      'sad': sad,
      'surprise': surprise,
      'neutral': neutral,
    };
  }
}

class EmotionModel {
  final String dominantEmotion;
  final EmotionScores emotionScores;

  EmotionModel({
    required this.dominantEmotion,
    required this.emotionScores,
    required bpm,
    required String emotion,
  });

  factory EmotionModel.fromJson(Map<String, dynamic> json) {
    return EmotionModel(
      dominantEmotion: json['dominant_emotion'] ?? '',
      emotionScores: EmotionScores.fromJson(json['emotion_scores'] ?? {}),
      bpm: null,
      emotion: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dominant_emotion': dominantEmotion,
      'emotion_scores': emotionScores.toJson(),
    };
  }
}

// Keep the original PredictionModel for backward compatibility if needed
class PredictionModel {
  final String label;
  final double score;

  PredictionModel({required this.label, required this.score});

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      label: json['label'] ?? '',
      score: (json['score'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'score': score,
    };
  }
}
