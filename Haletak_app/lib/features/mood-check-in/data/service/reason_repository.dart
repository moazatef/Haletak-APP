// lib/features/mood/data/repositories/mood_repository.dart
import 'package:aluna/features/mood-check-in/data/model/mood_entry.dart';
import 'package:aluna/features/mood-check-in/data/model/mood_reason.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return MoodRepository(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
});

class MoodRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  MoodRepository(this._firestore, this._auth);

  // Get current user ID or throw an error if not logged in
  String get _userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return user.uid;
  }

  // Collection references
  CollectionReference get _reasonsCollection =>
      _firestore.collection('users').doc(_userId).collection('reasons');

  CollectionReference get _moodEntriesCollection =>
      _firestore.collection('users').doc(_userId).collection('mood_entries');

  // Get predefined reasons
  Future<List<MoodReason>> getPredefinedReasons() async {
    try {
      // First check if the user already has reasons in their collection
      final userReasonsSnapshot = await _reasonsCollection.get();

      if (userReasonsSnapshot.docs.isNotEmpty) {
        return userReasonsSnapshot.docs
            .map((doc) =>
                MoodReason.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      }

      // If not, fetch from predefined reasons collection and add to user's collection
      final predefinedSnapshot =
          await _firestore.collection('predefined_reasons').get();

      // If predefined collection is empty, add default reasons
      if (predefinedSnapshot.docs.isEmpty) {
        final defaultReasons = [
          'Family',
          'Self esteem',
          'Sleep',
          'Social',
          'Work',
          'Hobbies',
          'Breakup',
          'Weather',
          'Partner',
          'Party',
          'Love',
          'Food'
        ];

        final batch = _firestore.batch();
        for (var reason in defaultReasons) {
          batch.set(_reasonsCollection.doc(), {
            'name': reason,
            'usageCount': 0,
          });
        }
        await batch.commit();
      } else {
        // Add predefined reasons to user's collection
        final batch = _firestore.batch();
        for (var doc in predefinedSnapshot.docs) {
          final data = doc.data();
          batch.set(_reasonsCollection.doc(), {
            'name': data['name'],
            'usageCount': 0,
          });
        }
        await batch.commit();
      }

      // Fetch the now populated user reasons
      final updatedSnapshot = await _reasonsCollection.get();
      return updatedSnapshot.docs
          .map((doc) =>
              MoodReason.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting predefined reasons: $e');
      return [];
    }
  }

  // Get recently used reasons
  Future<List<MoodReason>> getRecentlyUsedReasons() async {
    try {
      final snapshot = await _reasonsCollection
          .where('lastUsed', isNull: false)
          .orderBy('lastUsed', descending: true)
          .limit(4)
          .get();

      return snapshot.docs
          .map((doc) =>
              MoodReason.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting recently used reasons: $e');
      return [];
    }
  }

  // Search reasons
  Future<List<MoodReason>> searchReasons(String query) async {
    try {
      // Firestore doesn't support direct string contains queries
      // So we'll fetch all and filter on the client side
      final snapshot = await _reasonsCollection.get();

      final allReasons = snapshot.docs
          .map((doc) =>
              MoodReason.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      if (query.isEmpty) return allReasons;

      return allReasons
          .where((reason) =>
              reason.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      print('Error searching reasons: $e');
      return [];
    }
  }

  // Add custom reason
  Future<MoodReason?> addCustomReason(String name) async {
    try {
      final docRef = await _reasonsCollection.add({
        'name': name,
        'usageCount': 0,
        'lastUsed': null,
      });

      final doc = await docRef.get();
      return MoodReason.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      print('Error adding custom reason: $e');
      return null;
    }
  }

  // Update reason usage
  Future<void> updateReasonUsage(List<String> reasonIds) async {
    try {
      final batch = _firestore.batch();
      final now = DateTime.now();

      for (var id in reasonIds) {
        final docRef = _reasonsCollection.doc(id);
        final doc = await docRef.get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          batch.update(docRef, {
            'usageCount': (data['usageCount'] ?? 0) + 1,
            'lastUsed': now.toIso8601String(),
          });
        }
      }

      await batch.commit();
    } catch (e) {
      print('Error updating reason usage: $e');
    }
  }

  // Save mood entry
  Future<String?> saveMoodEntry({
    required int moodScore,
    required List<String> reasonIds,
    String? notes,
  }) async {
    try {
      // Update reason usage
      await updateReasonUsage(reasonIds);

      // Create mood entry
      final docRef = await _moodEntriesCollection.add({
        'moodScore': moodScore,
        'timestamp': Timestamp.now(),
        'reasonIds': reasonIds,
        'notes': notes,
      });

      return docRef.id;
    } catch (e) {
      print('Error saving mood entry: $e');
      return null;
    }
  }

  // Get mood entries
  Future<List<MoodEntry>> getMoodEntries({int limit = 30}) async {
    try {
      final snapshot = await _moodEntriesCollection
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) =>
              MoodEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting mood entries: $e');
      return [];
    }
  }
}
