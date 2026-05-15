import 'package:get/get.dart';

import '../../../data/dummy/dummy_data.dart';
import '../../../routes/app_routes.dart';

class CategoryPickerController extends GetxController {
  List<String> get categories => DummyData.categories;

  void selectCategory(String category) {
    Get.toNamed(
      AppRoutes.freelancersByCategory,
      arguments: {'category': category},
    );
  }
}
