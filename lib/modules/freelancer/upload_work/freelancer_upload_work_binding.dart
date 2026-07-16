import 'package:get/get.dart';

import '../../../data/repositories/work_repository.dart';
import 'freelancer_upload_work_controller.dart';

class FreelancerUploadWorkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FreelancerUploadWorkController>(
      () => FreelancerUploadWorkController(),
    );
    if (!Get.isRegistered<WorkRepository>()) {
      Get.put<WorkRepository>(WorkRepository(), permanent: true);
    }
  }
}
