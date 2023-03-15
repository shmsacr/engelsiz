import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engelsiz/data/models/user.dart' as app_user;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/models/user_with_id.dart';

final usersProvider = FutureProvider((ref) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  final snapShot = await FirebaseFirestore.instance
      .collection("users")
      .doc(auth.currentUser?.uid)
      .get();
  final userId = snapShot.id;
  final teacherIds = snapShot.data()!["teachers"];
  final data = await FirebaseFirestore.instance
      .collection("users")
      .where(FieldPath.documentId, whereIn: teacherIds)
      .get();

  return data.docs.map((doc) {
    return UserWithId(id: doc.id, user: app_user.User.fromJson(doc.data()));
  }).toList();
});

class UserProvider extends ChangeNotifier {
  List<String> _userIds = [];

  List<String> get userIds => _userIds;

  Future<void> fetchUserIds() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final snapShot = await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser?.uid)
        .collection("teachers")
        .get();
    _userIds = snapShot.docs.map((doc) => doc.id).toList();
    notifyListeners();
  }

  Future<Map<String, dynamic>?> fetchUser(String userId) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return snapshot.data();
  }
}
