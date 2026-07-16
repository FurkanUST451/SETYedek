import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/project_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../app/user_controller.dart';

class FreelancerProjectDetailController extends GetxController {
  final UserRepository _userRepo = Get.find<UserRepository>();
  final ChatRepository _chatRepo = Get.find<ChatRepository>();
  final UserController _userController = Get.find<UserController>();

  late final ProjectModel project;

  final Rx<UserModel?> client = Rx<UserModel?>(null);
  final RxBool loadingClient = false.obs;
  final RxBool isOpeningChat = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    project = args['project'] as ProjectModel;
    _loadClient();
  }

  Future<void> _loadClient() async {
    loadingClient.value = true;
    try {
      client.value = await _userRepo.fetchUser(project.clientId);
    } finally {
      loadingClient.value = false;
    }
  }

  Future<void> openChat() async {
    if (isOpeningChat.value) return;
    isOpeningChat.value = true;
    try {
      final me = _userController.currentUser;
      if (me == null) return;
      final clientName = client.value?.fullName ?? 'Müşteri';
      final projectTitle =
          project.title.isNotEmpty ? project.title : (project.category ?? '');

      String chatId = project.chatId ?? '';
      if (chatId.isEmpty) {
        final chat = await _chatRepo.getOrCreateChat(
          clientId: project.clientId,
          clientName: clientName,
          freelancerId: me.id,
          freelancerName: me.fullName,
          briefId: project.briefId ?? '',
          briefTitle: projectTitle,
        );
        chatId = chat.id;
      }

      Get.toNamed(
        AppRoutes.chatDetail,
        arguments: {
          'chatId': chatId,
          'otherUserName': clientName,
          'briefTitle': projectTitle,
          'returnRoute': AppRoutes.freelancerHome,
        },
      );
    } catch (e, st) {
      debugPrint('openChat error: $e\n$st');
      Get.snackbar(
        'Hata',
        'Sohbet başlatılamadı: $e',
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        duration: const Duration(seconds: 6),
      );
    } finally {
      isOpeningChat.value = false;
    }
  }
}
