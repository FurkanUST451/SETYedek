import 'package:get/get.dart';

import '../../../data/models/freelancer_model.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';

class FreelancerDetailController extends GetxController {
  late final FreelancerModel? freelancer;
  late final UserModel? user;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    freelancer = args?['freelancer'] as FreelancerModel?;
    user = args?['user'] as UserModel?;
  }

  void sendOffer() {
    Get.toNamed(AppRoutes.chatDetail, arguments: {
      'name': user?.name ?? 'Freelancer',
    });
  }

  void openChat() {
    Get.toNamed(AppRoutes.chatDetail, arguments: {'name': user?.name});
  }
}
