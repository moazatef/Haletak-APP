// lib/data/models/medication_list_model.dart
class MedicationListModel {
  final String name;
  final String type;

  MedicationListModel({
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
    };
  }

  factory MedicationListModel.fromJson(Map<String, dynamic> json) {
    return MedicationListModel(
      name: json['name'] ?? '',
      type: json['type'] ?? 'other',
    );
  }
}
