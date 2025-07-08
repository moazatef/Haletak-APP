class MedicationModel {
  final String? type; // "prescribed", "otc", "none", "prefer_not_to_say"

  MedicationModel({
    this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'medicationType': type,
    };
  }

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      type: json['medicationType'],
    );
  }
}
