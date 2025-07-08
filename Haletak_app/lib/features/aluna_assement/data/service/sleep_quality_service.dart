// lib/data/services/sleep_quality_service.dart
import 'package:aluna/features/aluna_assement/data/model/sleep_quality_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SleepQualityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId =>
      _auth.currentUser?.uid ??
      'temp_user_${DateTime.now().millisecondsSinceEpoch}';

  // Save user sleep quality
  Future<void> saveSleepQuality(SleepQuality sleepQuality) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'sleepQuality': sleepQuality.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving sleep quality: $e');
      rethrow;
    }
  }

  // Get user's sleep quality
  Future<SleepQuality?> getSleepQuality() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('sleepQuality')) {
          return SleepQuality.fromMap(data['sleepQuality']);
        }
      }
      return null;
    } catch (e) {
      print('Error getting sleep quality: $e');
      return null;
    }
  }
}
