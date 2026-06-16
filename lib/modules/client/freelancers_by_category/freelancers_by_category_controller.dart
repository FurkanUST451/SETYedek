import 'package:get/get.dart';

import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/freelancer_model.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';

class FreelancersByCategoryController extends GetxController {
  late final String category;

  final RxList<String> selectedIds = <String>[].obs;
  static const int maxSelections = 5;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    category = (args?['category'] as String?) ?? '';
  }

  List<FreelancerModel> get freelancers =>
      DummyData.freelancers.where((f) => f.category == category).toList();

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

  bool isSelected(FreelancerModel f) => selectedIds.contains(f.userId);

  void toggleSelect(FreelancerModel f) {
    if (isSelected(f)) {
      selectedIds.remove(f.userId);
    } else if (selectedIds.length < maxSelections) {
      selectedIds.add(f.userId);
    }
  }

  void openDetail(FreelancerModel f) {
    Get.toNamed(
      AppRoutes.freelancerDetail,
      arguments: {'freelancer': f, 'user': userFor(f)},
    );
  }

  void sendOffers() {
    if (selectedIds.isEmpty) return;
    Get.toNamed(
      AppRoutes.chatDetail,
      arguments: {
        'name': 'Proje Teklifi',
        'selectedIds': selectedIds.toList(),
      },
    );
  }
}
