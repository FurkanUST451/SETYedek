import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class SendOfferController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxString selectedBudget = ''.obs;
  final RxString selectedTimeline = ''.obs;
  final RxBool isRecording = false.obs;
  final RxBool isSubmitting = false.obs;

  static const budgetOptions = ['\$', '\$\$', '\$\$\$', '\$\$\$\$'];
  static const timelineOptions = ['1 Hafta', '2 Hafta', '1 Ay', '2+ Ay'];

  Future<void> submit() async {
    isSubmitting.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    isSubmitting.value = false;
    Get.toNamed(AppRoutes.projectMode);
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
