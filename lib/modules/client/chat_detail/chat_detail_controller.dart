import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatDetailController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  late final String chatName;

  final RxList<String> messages = <String>[
    'Selam! Projen hakkında konuşalım.',
    'Tabii, ne zaman uygunsun?',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    chatName = args?['name'] as String? ?? 'Sohbet';
  }

  void send() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    messages.add(text);
    messageController.clear();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
