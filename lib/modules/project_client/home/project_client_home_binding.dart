import 'package:get/get.dart';

import 'project_client_home_controller.dart';

class ProjectClientHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProjectClientHomeController());
  }
}
