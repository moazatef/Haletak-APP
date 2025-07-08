// lib/data/services/user_service.dart
import 'package:aluna/features/aluna_assement/data/model/user_age.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId =>
      _auth.currentUser?.uid ??
      'temp_user_${DateTime.now().millisecondsSinceEpoch}';

  // Save user age
  Future<void> saveUserAge(int age) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'age': age,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving age: $e');
      rethrow;
    }
  }

  Future<void> saveUserWeight(int weightKg) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'weightKg': weightKg,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving weight: $e');
      rethrow;
    }
  }

  // Update specific field of user data
  Future<void> updateUserField(String field, dynamic value) async {
    try {
      await _firestore.collection('users').doc(userId).update({field: value});
    } catch (e) {
      throw Exception('Failed to update user field: $e');
    }
  }

  Future<void> saveUserProfessionalHelpStatus(bool hasSoughtHelp) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'hasSoughtProfessionalHelp': hasSoughtHelp,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving professional help status: $e');
      rethrow;
    }
  }

  // Get user data
  Future<UserModel?> getUserData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
}
