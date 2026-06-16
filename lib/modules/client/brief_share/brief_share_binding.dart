import 'package:get/get.dart';

import 'brief_share_controller.dart';

class BriefShareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BriefShareController());
  }
}
