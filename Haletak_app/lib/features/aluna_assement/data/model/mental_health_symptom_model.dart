class MentalHealthSymptom {
  final String symptom;
  final bool isSelected;

  MentalHealthSymptom({required this.symptom, this.isSelected = false});

  Map<String, dynamic> toJson() =>
      {'symptom': symptom, 'isSelected': isSelected};

  factory MentalHealthSymptom.fromJson(Map<String, dynamic> json) {
    return MentalHealthSymptom(
      symptom: json['symptom'],
      isSelected: json['isSelected'] ?? false,
    );
  }
}
