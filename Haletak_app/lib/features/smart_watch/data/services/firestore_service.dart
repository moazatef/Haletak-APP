import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/heart_data_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId = "demo_user_001";

  Stream<HeartData?> getLatestHeartData() {
    return _db
        .collection("users")
        .doc(userId)
        .collection("heart_rates")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return HeartData.fromMap(snapshot.docs.first.data());
    });
  }
}
