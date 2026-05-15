import 'package:get/get.dart';

import 'category_picker_controller.dart';

class CategoryPickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryPickerController());
  }
}
