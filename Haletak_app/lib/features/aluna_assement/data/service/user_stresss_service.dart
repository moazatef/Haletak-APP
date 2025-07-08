import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StressLevelService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String get userId =>
      _auth.currentUser?.uid ??
      'temp_user_${DateTime.now().millisecondsSinceEpoch}';

  /// Save stress level to Firestore (Static Method)
  static Future<void> saveStressLevel(int level) async {
    try {
      await _firestore.collection('users').doc(userId).set(
        {
          'stressLevel': level,
          'timestamp': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print("Error saving stress level: $e");
      rethrow;
    }
  }
}
