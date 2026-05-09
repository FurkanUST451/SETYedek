import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/set_button.dart';
import '../../../widgets/set_text_field.dart';
import 'send_offer_controller.dart';

class SendOfferView extends GetView<SendOfferController> {
  const SendOfferView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teklif Gönder')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                SetTextField(
                  label: 'Tutar (₺)',
                  hint: 'Ör. 25000',
                  controller: controller.amountController,
                  keyboardType: TextInputType.number,
                  validator: Validators.required,
                ),
                const SizedBox(height: AppSpacing.md),
                SetTextField(
                  label: 'Mesaj',
                  hint: 'Projenle ilgili kısa bir not yaz...',
                  controller: controller.messageController,
                  maxLines: 5,
                  validator: Validators.required,
                ),
                const SizedBox(height: AppSpacing.xl),
                Obx(() => SetButton(
                      text: 'Teklifi Gönder',
                      onPressed: controller.submit,
                      isLoading: controller.isSubmitting.value,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
