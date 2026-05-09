import '../models/user_model.dart';

/// User repository — Firestore `users` koleksiyonu için arayüz.
class UserRepository {
  UserRepository();

  Future<UserModel?> fetchUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return null;
  }

  Future<void> upsertUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> updateRole(String userId, UserRole role) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
