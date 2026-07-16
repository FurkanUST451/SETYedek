import 'package:get/get.dart';

import 'project_detail_controller.dart';

class FreelancerProjectDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FreelancerProjectDetailController());
  }
}
