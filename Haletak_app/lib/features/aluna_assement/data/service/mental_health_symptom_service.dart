import 'package:aluna/features/aluna_assement/data/model/mental_health_symptom_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MentalHealthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId =>
      _auth.currentUser?.uid ??
      'temp_user_${DateTime.now().millisecondsSinceEpoch}';

  Future<void> saveMentalHealthSymptoms(
      List<MentalHealthSymptom> symptoms) async {
    try {
      List<Map<String, dynamic>> symptomsJson =
          symptoms.map((s) => s.toJson()).toList();
      await _firestore.collection('users').doc(userId).set(
        {'mentalHealthSymptoms': symptomsJson},
        SetOptions(merge: true),
      );
    } catch (e) {
      print('Error saving mental health symptoms: $e');
      rethrow;
    }
  }
}
