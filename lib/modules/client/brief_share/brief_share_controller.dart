import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class BriefShareController extends GetxController {
  late final String category;

  final briefText = TextEditingController();
  final RxInt charCount = 0.obs;

  final RxBool isRecording = false.obs;
  final RxInt recordSeconds = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    category = (args?['category'] as String?) ?? '';
    briefText.addListener(() => charCount.value = briefText.text.length);
  }

  String get formattedTime {
    final m = (recordSeconds.value ~/ 60).toString().padLeft(2, '0');
    final s = (recordSeconds.value % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void toggleRecording() {
    if (isRecording.value) {
      _timer?.cancel();
      isRecording.value = false;
    } else {
      isRecording.value = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        recordSeconds.value++;
      });
    }
  }

  void submit() {
    _timer?.cancel();
    Get.toNamed(
      AppRoutes.projectMode,
      arguments: {'category': category},
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    briefText.dispose();
    super.onClose();
  }
}
