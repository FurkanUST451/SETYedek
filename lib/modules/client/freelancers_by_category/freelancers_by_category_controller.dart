import 'package:get/get.dart';

import '../../../data/models/freelancer_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/freelancer_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../routes/app_routes.dart';

class FreelancersByCategoryController extends GetxController {
  final FreelancerRepository _freelancerRepo;
  final UserRepository _userRepo;

  FreelancersByCategoryController(this._freelancerRepo, this._userRepo);

  late final String category;

  final RxList<FreelancerModel> freelancers = <FreelancerModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMsg = ''.obs;
  final RxList<String> selectedIds = <String>[].obs;
  static const int maxSelections = 5;

  final Map<String, UserModel> _userCache = {};

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    category = (args?['category'] as String?) ?? '';
    _load();
  }

  Future<void> _load() async {
    try {
      isLoading.value = true;
      errorMsg.value = '';
      final list = await _freelancerRepo.filterByCategory(category);
      final users = await Future.wait(list.map((f) => _userRepo.fetchUser(f.userId)));
      for (int i = 0; i < list.length; i++) {
        if (users[i] != null) _userCache[list[i].userId] = users[i]!;
      }
      freelancers.assignAll(list);
    } catch (_) {
      errorMsg.value = 'Freelancerlar yüklenemedi.';
    } finally {
      isLoading.value = false;
    }
  }

  UserModel userFor(FreelancerModel f) =>
      _userCache[f.userId] ??
      UserModel(
        id: f.userId,
        name: 'Bilinmiyor',
        email: '',
        role: UserRole.freelancer,
        createdAt: DateTime.now(),
      );

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
