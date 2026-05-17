import 'package:get/get.dart';

import '../../app/auth_controller.dart';

class ClientHomeController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();

  final RxInt currentIndex = 2.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args?['tab'] != null) currentIndex.value = args!['tab'] as int;
  }

  void changeTab(int index) => currentIndex.value = index;

  Future<void> logout() => _auth.logout();
}
