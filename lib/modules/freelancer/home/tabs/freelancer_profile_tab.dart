import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/set_avatar.dart';
import '../../../../widgets/set_button.dart';
import '../../../../widgets/set_card.dart';
import '../../../../widgets/set_section_header.dart';
import '../../../app/auth_controller.dart';
import '../../../app/theme_controller.dart';
import '../../../app/user_controller.dart';

class FreelancerProfileTab extends StatelessWidget {
  const FreelancerProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final userC = Get.find<UserController>();
    final themeC = Get.find<ThemeController>();
    final authC = Get.find<AuthController>();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          120,
        ),
        children: [
          SetSectionHeader(
            eyebrow: 'ACCOUNT',
            title: 'Profil',
            large: true,
          ),
          const SizedBox(height: AppSpacing.xl),
          Obx(() {
            final u = userC.currentUser;
            return SetCard(
              glow: true,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  SetAvatar(name: u?.name ?? 'Freelancer', size: 64),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CREATOR',
                          style: AppTextStyles.eyebrow.copyWith(
                            color: AppColors.accentCyan,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          u?.name ?? 'Freelancer',
                          style: AppTextStyles.heading2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          u?.email ?? '',
                          style: AppTextStyles.body2.copyWith(
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: AppSpacing.xl),
          // Stats row
          Row(
            children: [
              Expanded(child: _StatCard(value: '12', label: 'Proje')),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _StatCard(value: '4.9', label: 'Puan')),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _StatCard(value: '3y', label: 'Deneyim')),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          SetCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 4,
            ),
            child: Obx(() => SwitchListTile(
                  value: themeC.isDark,
                  onChanged: (_) => themeC.toggle(),
                  title: Text(
                    'Karanlık tema',
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  activeThumbColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                )),
          ),
          const SizedBox(height: AppSpacing.xl),
          SetButton(
            text: 'Rolümü Değiştir',
            variant: SetButtonVariant.secondary,
            icon: Icons.swap_horiz,
            onPressed: () => Get.offAllNamed(AppRoutes.roleSelection),
          ),
          const SizedBox(height: AppSpacing.md),
          SetButton(
            text: 'Çıkış Yap',
            variant: SetButtonVariant.outline,
            icon: Icons.logout,
            onPressed: () async {
              await authC.logout();
              Get.offAllNamed(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return SetCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTextStyles.displayXL.copyWith(
              color: AppColors.primary,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.eyebrow.copyWith(color: secondaryColor),
          ),
        ],
      ),
    );
  }
}
