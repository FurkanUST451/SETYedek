import 'package:get/get.dart';

import 'portfolio_project_detail_controller.dart';

class PortfolioProjectDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortfolioProjectDetailController());
  }
}
