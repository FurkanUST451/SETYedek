import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/set_avatar.dart';
import '../../../../widgets/set_button.dart';
import '../../../../widgets/set_card.dart';
import '../../../app/auth_controller.dart';
import '../../../app/theme_controller.dart';
import '../../../app/user_controller.dart';

class FreelancerProfileTab extends StatelessWidget {
  const FreelancerProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userC = Get.find<UserController>();
    final themeC = Get.find<ThemeController>();
    final authC = Get.find<AuthController>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Text('Profil', style: AppTextStyles.heading1),
          const SizedBox(height: AppSpacing.lg),
          Obx(() {
            final u = userC.currentUser;
            return SetCard(
              child: Row(
                children: [
                  SetAvatar(name: u?.name ?? 'Freelancer', size: 64),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(u?.name ?? 'Freelancer',
                            style: AppTextStyles.heading3),
                        Text(
                          u?.email ?? '',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: AppSpacing.lg),
          SetCard(
            child: Obx(() => SwitchListTile(
                  value: themeC.isDark,
                  onChanged: (_) => themeC.toggle(),
                  title: const Text('Karanlık tema'),
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
