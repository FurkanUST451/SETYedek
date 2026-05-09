import 'package:get/get.dart';

import 'send_offer_controller.dart';

class SendOfferBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SendOfferController());
  }
}
