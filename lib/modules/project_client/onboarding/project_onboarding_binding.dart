import 'package:get/get.dart';

import 'project_onboarding_controller.dart';

class ProjectOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProjectOnboardingController());
  }
}
