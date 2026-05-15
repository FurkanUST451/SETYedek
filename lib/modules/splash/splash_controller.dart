import 'package:get/get.dart';

import '../../data/models/user_model.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';


class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _decideInitialRoute();
  }

  Future<void> _decideInitialRoute() async {
    await Future.delayed(const Duration(seconds: 2));

    // DEV: Onboarding tasarımı üzerinde çalışırken her açılışta gösteriyoruz.
    // Tasarım netleşince aşağıdaki hasOnboarded kontrolüne geri dönülecek.
    Get.offAllNamed(AppRoutes.onboarding);
    return;
    // ignore: dead_code
    final hasOnboarded =
        StorageService.read<bool>(StorageService.onboardingComplete) ?? false;
    final userId = StorageService.read<String>(StorageService.userId);
    final roleName = StorageService.read<String>(StorageService.userRole);

    // Onboarding hiç gösterilmemişse oraya gönder
    if (!hasOnboarded) {
      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }

    // Giriş yapılmamışsa login'e
    if (userId == null) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    // Rol seçilmemişse role selection'a
    if (roleName == null) {
      Get.offAllNamed(AppRoutes.roleSelection);
      return;
    }

    // Rol belirli → doğrudan home'a
    switch (UserRole.fromName(roleName)) {
      case UserRole.client:
        Get.offAllNamed(AppRoutes.clientHome);
      case UserRole.freelancer:
        Get.offAllNamed(AppRoutes.freelancerHome);
    }
  }
}
