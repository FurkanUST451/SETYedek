import 'package:get/get.dart';

import '../../../data/repositories/freelancer_repository.dart';
import '../../../data/repositories/user_repository.dart';
import 'freelancers_by_category_controller.dart';

class FreelancersByCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FreelancersByCategoryController(
          Get.find<FreelancerRepository>(),
          Get.find<UserRepository>(),
        ));
  }
}
