import 'package:get/get.dart';

import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/freelancer_model.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';

class FreelancersByCategoryController extends GetxController {
  late final String category;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    category = (args?['category'] as String?) ?? '';
  }

  List<FreelancerModel> get freelancers => DummyData.freelancers
      .where((f) => f.category == category)
      .toList();

  UserModel userFor(FreelancerModel f) {
    return DummyData.users.firstWhere(
      (u) => u.id == f.userId,
      orElse: () => UserModel(
        id: f.userId,
        name: 'Bilinmiyor',
        email: '',
        role: UserRole.freelancer,
        createdAt: DateTime.now(),
      ),
    );
  }

  void openDetail(FreelancerModel f) {
    Get.toNamed(
      AppRoutes.freelancerDetail,
      arguments: {'freelancer': f, 'user': userFor(f)},
    );
  }
}
