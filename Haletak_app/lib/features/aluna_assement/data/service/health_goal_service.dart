// lib/data/services/health_goal_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../model/health_goal.dart';

class HealthGoalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  CollectionReference get _goalsCollection => _firestore
      .collection('users')
      .doc(_getCurrentUserId())
      .collection('health_goals');

  // Get current user ID
  String _getCurrentUserId() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.uid;
  }

  // Save a health goal
  Future<void> saveHealthGoal(String goalType) async {
    try {
      final goalId = const Uuid().v4();
      final healthGoal = HealthGoal(
        id: goalId,
        goalType: goalType,
        createdAt: DateTime.now(),
      );

      await _goalsCollection.doc(goalId).set(healthGoal.toMap());
    } catch (e) {
      throw Exception('Failed to save health goal: $e');
    }
  }

  // Get user's most recent health goal
  Future<HealthGoal?> getLatestHealthGoal() async {
    try {
      final snapshot = await _goalsCollection
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      return HealthGoal.fromMap(
          snapshot.docs.first.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get latest health goal: $e');
    }
  }
}
