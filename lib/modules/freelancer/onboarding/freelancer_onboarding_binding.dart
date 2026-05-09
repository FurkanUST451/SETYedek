import 'package:get/get.dart';

import 'freelancer_onboarding_controller.dart';

class FreelancerOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FreelancerOnboardingController());
  }
}
