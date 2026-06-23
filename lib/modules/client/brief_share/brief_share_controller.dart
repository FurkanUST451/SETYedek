import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class BriefShareController extends GetxController {
  late final String category;

  final briefText = TextEditingController();
  final RxInt charCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    category = (args?['category'] as String?) ?? '';
    briefText.addListener(() => charCount.value = briefText.text.length);
  }

  void submit() {
    Get.toNamed(
      AppRoutes.projectMode,
      arguments: {'category': category},
    );
  }

  @override
  void onClose() {
    briefText.dispose();
    super.onClose();
  }
}
