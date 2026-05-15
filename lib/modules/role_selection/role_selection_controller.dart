import 'package:get/get.dart';

import '../../data/models/user_model.dart';
import '../../routes/app_routes.dart';
import '../app/user_controller.dart';

class RoleSelectionController extends GetxController {
  final UserController _user = Get.find<UserController>();

  void select(UserRole role) {
    _user.updateRole(role);
    switch (role) {
      case UserRole.client:
        Get.offAllNamed(AppRoutes.clientHome);
      case UserRole.freelancer:
        Get.offAllNamed(AppRoutes.freelancerOnboarding);
    }
  }
}
