import 'package:get/get.dart';

import '../../app/auth_controller.dart';

class ClientHomeController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();

  // Default to Ana Sayfa (index 2) — center tab in the 5-item nav.
  final RxInt currentIndex = 2.obs;

  void changeTab(int index) => currentIndex.value = index;

  Future<void> logout() => _auth.logout();
}
