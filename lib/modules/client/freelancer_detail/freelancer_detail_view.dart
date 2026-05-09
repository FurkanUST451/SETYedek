import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/set_avatar.dart';
import '../../../widgets/set_button.dart';
import '../../../widgets/set_card.dart';
import 'freelancer_detail_controller.dart';

class FreelancerDetailView extends GetView<FreelancerDetailController> {
  const FreelancerDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final f = controller.freelancer;
    final u = controller.user;
    final name = u?.name ?? 'Freelancer';

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Center(
              child: Column(
                children: [
                  SetAvatar(name: name, size: 96),
                  const SizedBox(height: AppSpacing.md),
                  Text(name, style: AppTextStyles.heading2),
                  if (f != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${f.category} · ${f.location}',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            if (f != null)
              SetCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hakkında', style: AppTextStyles.heading3),
                    const SizedBox(height: AppSpacing.sm),
                    Text(f.bio, style: AppTextStyles.body1),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: AppColors.primary, size: 18),
                        const SizedBox(width: 4),
                        Text(f.rating.toStringAsFixed(1),
                            style: AppTextStyles.body2),
                        const SizedBox(width: AppSpacing.lg),
                        const Icon(Icons.work_outline, size: 18),
                        const SizedBox(width: 4),
                        Text('${f.experience} yıl deneyim',
                            style: AppTextStyles.body2),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: AppSpacing.xl),
            SetButton(text: 'Teklif Gönder', onPressed: controller.sendOffer),
            const SizedBox(height: AppSpacing.md),
            SetButton(
              text: 'Mesaj Gönder',
              variant: SetButtonVariant.outline,
              onPressed: controller.openChat,
            ),
          ],
        ),
      ),
    );
  }
}
