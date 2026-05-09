import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/services/storage_service.dart';
import 'user_controller.dart';

class AuthController extends GetxController {
  final AuthRepository _repo = Get.find<AuthRepository>();
  final UserController _user = Get.find<UserController>();

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  bool get isLoggedIn =>
      _user.hasUser || StorageService.has(StorageService.userId);

  Future<bool> login({required String email, required String password}) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final user = await _repo.login(email: email, password: password);
      _user.setUser(user);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final user = await _repo.register(
        name: name,
        email: email,
        password: password,
      );
      _user.setUser(user);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _repo.logout();
      _user.clearUser();
    } finally {
      isLoading.value = false;
    }
  }
}
