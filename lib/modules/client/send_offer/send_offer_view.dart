import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/set_button.dart';
import '../../../widgets/set_card.dart';
import '../../../widgets/set_section_header.dart';
import '../../../widgets/set_text_field.dart';
import 'send_offer_controller.dart';

class SendOfferView extends GetView<SendOfferController> {
  const SendOfferView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: isDark ? 0.22 : 0.14),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SetSectionHeader(
                    eyebrow: 'NEW OFFER',
                    title: 'Teklif Gönder',
                    description: 'Bütçeni ve mesajını net belirt.',
                    large: true,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // Amount mega display + input
                  SetCard(
                    glow: true,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AMOUNT',
                            style: AppTextStyles.eyebrow.copyWith(
                              color: secondaryColor,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '₺',
                                style: AppTextStyles.displayXL.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 36,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: TextFormField(
                                  controller: controller.amountController,
                                  keyboardType: TextInputType.number,
                                  validator: Validators.required,
                                  style: AppTextStyles.displayXL.copyWith(
                                    color: AppColors.primary,
                                  ),
                                  cursorColor: AppColors.primary,
                                  decoration: InputDecoration(
                                    hintText: '0',
                                    hintStyle:
                                        AppTextStyles.displayXL.copyWith(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.3),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Container(
                            height: 0.5,
                            color: isDark
                                ? AppColors.border
                                : AppColors.borderLight,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          SetTextField(
                            label: 'Mesaj',
                            hint:
                                'Projenle ilgili kısa bir not yaz...',
                            controller: controller.messageController,
                            maxLines: 5,
                            validator: Validators.required,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Obx(() => SetButton(
                        text: 'Teklifi Gönder',
                        icon: Icons.send_outlined,
                        onPressed: controller.submit,
                        isLoading: controller.isSubmitting.value,
                        size: SetButtonSize.hero,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
