import 'package:get/get.dart';

import '../../app/auth_controller.dart';

class ClientHomeController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();

  final RxInt currentIndex = 0.obs;

  void changeTab(int index) => currentIndex.value = index;

  Future<void> logout() => _auth.logout();
}
