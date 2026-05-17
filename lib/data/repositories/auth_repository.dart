import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    return UserModel(
      id: user.uid,
      name: user.displayName ?? email.split('@').first,
      email: user.email!,
      role: UserRole.client,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    await user.updateDisplayName(name);
    return UserModel(
      id: user.uid,
      name: name,
      email: user.email!,
      role: UserRole.client,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  User? get currentFirebaseUser => _auth.currentUser;
}
