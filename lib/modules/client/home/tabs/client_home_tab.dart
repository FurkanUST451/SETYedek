import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../app/user_controller.dart';

class ClientHomeTab extends StatelessWidget {
  const ClientHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final user = Get.find<UserController>();

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.lg,
          120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Obx(() {
              final u = user.currentUser;
              final firstName = (u?.name ?? '').split(' ').first;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HOŞ GELDİN',
                    style: AppTextStyles.eyebrow.copyWith(
                      color: AppColors.accentCyan,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    firstName.isEmpty ? 'Merhaba' : 'Merhaba, $firstName',
                    style: AppTextStyles.displayXL.copyWith(fontSize: 36),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Bir sonraki projen için ekibini bulmaya hazır mısın?',
                    style: AppTextStyles.body1.copyWith(
                      color: secondaryColor,
                      height: 1.45,
                    ),
                  ),
                ],
              );
            }),
            const Spacer(),
            // Mega CTA — Projeni yaptır
            _ProjectCta(
              onTap: () => Get.toNamed(AppRoutes.categoryPicker),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class _ProjectCta extends StatelessWidget {
  const _ProjectCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.xl);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.xl,
          ),
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDeep],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.45),
                blurRadius: 40,
                offset: const Offset(0, 16),
                spreadRadius: -8,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YENİ PROJE',
                      style: AppTextStyles.eyebrow.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Projeni yaptır',
                      style: AppTextStyles.heading1.copyWith(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Kategori seç, doğru freelancer\'a ulaş.',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.22),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 0.8,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
