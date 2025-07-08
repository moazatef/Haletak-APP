// lib/data/services/user_profile_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_profile.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  CollectionReference get _usersCollection => _firestore.collection('users');

  // Get current user ID
  String _getCurrentUserId() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.uid;
  }

  // Update user gender
  Future<void> updateUserGender(String gender) async {
    try {
      final userId = _getCurrentUserId();

      await _usersCollection.doc(userId).set({
        'gender': gender,
        'updatedAt': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update gender: $e');
    }
  }

  // Get user profile
  Future<UserProfile?> getUserProfile() async {
    try {
      final userId = _getCurrentUserId();
      final snapshot = await _usersCollection.doc(userId).get();

      if (!snapshot.exists) {
        return null;
      }

      final data = snapshot.data() as Map<String, dynamic>;
      return UserProfile.fromMap(data);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }
}
