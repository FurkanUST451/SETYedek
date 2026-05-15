import 'package:get/get.dart';

import 'freelancers_by_category_controller.dart';

class FreelancersByCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FreelancersByCategoryController());
  }
}
