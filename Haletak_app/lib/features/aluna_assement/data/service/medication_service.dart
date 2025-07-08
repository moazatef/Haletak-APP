// lib/data/services/medication_service.dart
import 'package:aluna/features/aluna_assement/data/model/medication_list_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Medication types
  static const List<String> medicationTypes = [
    'depression',
    'anxiety',
    'stress',
    'other'
  ];

  // Get current user ID
  String get userId =>
      _auth.currentUser?.uid ??
      'temp_user_${DateTime.now().millisecondsSinceEpoch}';

  // Save single medication
  Future<void> saveMedicationInfo(
    String medicationName, {
    String type = 'other',
  }) async {
    try {
      // Validate medication type
      type = medicationTypes.contains(type) ? type : 'other';

      final medication = MedicationListModel(
        name: medicationName,
        type: type,
      );

      await _firestore.collection('users').doc(userId).set({
        'medication': medication.toJson(),
        'updatedAt': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving medication info: $e');
      rethrow;
    }
  }

  // Save multiple medications
  Future<void> saveMedications(List<MedicationListModel> medications) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'medications': medications.map((med) => med.toJson()).toList(),
        'updatedAt': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving medications: $e');
      rethrow;
    }
  }

  // Get user's medications
  Future<List<MedicationListModel>> getUserMedications() async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (!doc.exists) return [];

      // ignore: unnecessary_cast
      final data = doc.data() as Map<String, dynamic>?;

      // Check for single medication
      if (data?.containsKey('medication') == true) {
        return [MedicationListModel.fromJson(data!['medication'])];
      }

      // Check for multiple medications
      if (data?.containsKey('medications') == true) {
        return (data!['medications'] as List)
            .map((medData) => MedicationListModel.fromJson(medData))
            .toList();
      }

      return [];
    } catch (e) {
      print('Error retrieving medications: $e');
      return [];
    }
  }

  // Delete all user medications
  Future<void> clearMedications() async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'medications': FieldValue.delete(),
        'medication': FieldValue.delete(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error clearing medications: $e');
      rethrow;
    }
  }

  // Get medications by type
  Future<List<MedicationListModel>> getMedicationsByType(String type) async {
    try {
      final medications = await getUserMedications();
      return medications.where((med) => med.type == type).toList();
    } catch (e) {
      print('Error filtering medications by type: $e');
      return [];
    }
  }

  // Check if user has medications
  Future<bool> hasMedications() async {
    try {
      final medications = await getUserMedications();
      return medications.isNotEmpty;
    } catch (e) {
      print('Error checking medications: $e');
      return false;
    }
  }
}
