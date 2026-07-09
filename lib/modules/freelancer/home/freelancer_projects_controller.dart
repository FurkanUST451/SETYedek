import 'package:get/get.dart';

import '../../../data/models/project_model.dart';
import '../../../data/repositories/project_repository.dart';
import '../../app/user_controller.dart';

class FreelancerProjectsController extends GetxController {
  final ProjectRepository _projectRepo = Get.find<ProjectRepository>();
  final UserController _userController = Get.find<UserController>();

  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  Future<void> loadProjects() async {
    try {
      isLoading.value = true;
      final freelancerId = _userController.currentUser?.id ?? '';
      if (freelancerId.isEmpty) {
        projects.clear();
        return;
      }
      projects.assignAll(await _projectRepo.fetchByFreelancer(freelancerId));
    } catch (_) {
      projects.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
