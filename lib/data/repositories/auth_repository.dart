import '../models/user_model.dart';

/// Auth repository — Firebase Auth entegrasyonu için arayüz.
/// Şimdilik mock; ileride [FirebaseAuth.instance] ile bağlanacak.
class AuthRepository {
  AuthRepository();

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return UserModel(
      id: 'mock-${email.hashCode}',
      name: email.split('@').first,
      email: email,
      role: UserRole.client,
      createdAt: DateTime.now(),
    );
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return UserModel(
      id: 'mock-${email.hashCode}',
      name: name,
      email: email,
      role: UserRole.client,
      createdAt: DateTime.now(),
    );
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
