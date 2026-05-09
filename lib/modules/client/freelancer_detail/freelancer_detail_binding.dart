import 'package:get/get.dart';

import 'freelancer_detail_controller.dart';

class FreelancerDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FreelancerDetailController());
  }
}
