import 'dart:async';

import 'package:get/get.dart';

import '../../../data/models/project_model.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../app/user_controller.dart';

class FreelancerProjectsController extends GetxController {
  final ProjectRepository _projectRepo = Get.find<ProjectRepository>();
  final UserRepository _userRepo = Get.find<UserRepository>();
  final UserController _userController = Get.find<UserController>();

  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxMap<String, String> clientNames = <String, String>{}.obs;
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
      final fetched = await _projectRepo.fetchByFreelancer(freelancerId);
      projects.assignAll(fetched);
      unawaited(_loadClientNames(fetched));
    } catch (_) {
      projects.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadClientNames(List<ProjectModel> list) async {
    final missingIds = list
        .map((p) => p.clientId)
        .toSet()
        .where((id) => id.isNotEmpty && !clientNames.containsKey(id));
    await Future.wait(missingIds.map((id) async {
      final client = await _userRepo.fetchUser(id);
      if (client != null) {
        clientNames[id] = client.fullName;
      }
    }));
  }
}
