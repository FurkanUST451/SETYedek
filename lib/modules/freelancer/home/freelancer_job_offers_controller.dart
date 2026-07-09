import 'package:get/get.dart';

import '../../../data/models/brief_model.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/brief_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../app/user_controller.dart';

class FreelancerJobOffersController extends GetxController {
  final BriefRepository _briefRepo = Get.find<BriefRepository>();
  final ProjectRepository _projectRepo = Get.find<ProjectRepository>();
  final UserController _userController = Get.find<UserController>();

  final RxList<BriefModel> offers = <BriefModel>[].obs;
  // Bu freelancer için zaten aktif projeye dönüşmüş brief'ler (briefId -> proje) —
  // kart bu map'teyse sade "Kabul Edildi" kartı, anlaşılan ücretiyle gösterilir.
  final RxMap<String, ProjectModel> acceptedProjectsByBriefId =
      <String, ProjectModel>{}.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadOffers();
  }

  Future<void> loadOffers() async {
    try {
      isLoading.value = true;
      final freelancerId = _userController.currentUser?.id ?? '';
      if (freelancerId.isEmpty) {
        offers.clear();
        acceptedProjectsByBriefId.clear();
        return;
      }
      final results = await Future.wait([
        _briefRepo.fetchByFreelancer(freelancerId),
        _projectRepo.fetchByFreelancer(freelancerId),
      ]);
      offers.assignAll(results[0] as List<BriefModel>);
      acceptedProjectsByBriefId.assignAll({
        for (final p in results[1] as List<ProjectModel>)
          if (p.briefId != null) p.briefId!: p,
      });
    } catch (_) {
      offers.clear();
      acceptedProjectsByBriefId.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
