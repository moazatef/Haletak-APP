// data/model/assessment_response.dart
class AssessmentResponse {
  final int questionNumber;
  final String questionText;
  final String response;
  final DateTime timestamp;

  AssessmentResponse({
    required this.questionNumber,
    required this.questionText,
    required this.response,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'questionNumber': questionNumber,
      'questionText': questionText,
      'response': response,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory AssessmentResponse.fromJson(Map<String, dynamic> json) {
    return AssessmentResponse(
      questionNumber: json['questionNumber'],
      questionText: json['questionText'],
      response: json['response'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
