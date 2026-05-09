import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/freelancer_repository.dart';
import '../../data/repositories/user_repository.dart';
import 'auth_controller.dart';
import 'theme_controller.dart';
import 'user_controller.dart';

/// Uygulama başlarken global olarak ayağa kaldırılan controller'lar
/// ve repository'ler. `permanent: true` ile bellekte kalırlar.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Repositories
    Get.put<AuthRepository>(AuthRepository(), permanent: true);
    Get.put<UserRepository>(UserRepository(), permanent: true);
    Get.put<FreelancerRepository>(FreelancerRepository(), permanent: true);

    // Controllers
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
