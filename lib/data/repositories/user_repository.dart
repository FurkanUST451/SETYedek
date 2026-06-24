import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  Future<UserModel?> fetchUser(String userId) async {
    final doc = await _users.doc(userId).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromJson(doc.data()!);
  }

  Future<void> upsertUser(UserModel user) async {
    await _users.doc(user.id).set(user.toJson(), SetOptions(merge: true));
  }

  Future<void> updateRole(String userId, UserRole role) async {
    await _users.doc(userId).update({'role': role.name});
  }
}
