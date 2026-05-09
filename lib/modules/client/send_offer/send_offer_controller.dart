import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendOfferController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final messageController = TextEditingController();
  final RxBool isSubmitting = false.obs;

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    isSubmitting.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
    isSubmitting.value = false;
    Get.back();
    Get.snackbar('Teklif gönderildi', 'Teklifin başarıyla iletildi.');
  }

  @override
  void onClose() {
    amountController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
