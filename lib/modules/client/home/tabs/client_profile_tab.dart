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

class ClientProfileTab extends StatelessWidget {
  const ClientProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final user = Get.find<UserController>();
    final theme = Get.find<ThemeController>();
    final auth = Get.find<AuthController>();

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
            final u = user.currentUser;
            return SetCard(
              glow: true,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  SetAvatar(name: u?.name ?? 'Misafir', size: 64),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MEMBER',
                          style: AppTextStyles.eyebrow.copyWith(
                            color: AppColors.accentCyan,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          u?.name ?? 'Misafir',
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
          SetSectionHeader(eyebrow: 'PREFERENCES', title: 'Görünüm'),
          const SizedBox(height: AppSpacing.md),
          SetCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 4,
            ),
            child: Obx(() => SwitchListTile(
                  value: theme.isDark,
                  onChanged: (_) => theme.toggle(),
                  title: Text(
                    'Karanlık tema',
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Cinematic mood için aç',
                    style: AppTextStyles.caption.copyWith(
                      color: secondaryColor,
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
              await auth.logout();
              Get.offAllNamed(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}
