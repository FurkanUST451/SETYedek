import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/user_model.dart';
import '../../widgets/set_card.dart';
import 'role_selection_controller.dart';

class RoleSelectionView extends GetView<RoleSelectionController> {
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                AppStrings.roleSelectionTitle,
                style: AppTextStyles.heading1,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Sonra istediğin zaman rolünü değiştirebilirsin.',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _RoleCard(
                icon: Icons.movie_filter_outlined,
                title: AppStrings.roleProjectClient,
                description: AppStrings.roleProjectClientDesc,
                onTap: () => controller.select(UserRole.projectClient),
              ),
              const SizedBox(height: AppSpacing.md),
              _RoleCard(
                icon: Icons.search,
                title: AppStrings.roleClient,
                description: AppStrings.roleClientDesc,
                onTap: () => controller.select(UserRole.client),
              ),
              const SizedBox(height: AppSpacing.md),
              _RoleCard(
                icon: Icons.workspace_premium_outlined,
                title: AppStrings.roleFreelancer,
                description: AppStrings.roleFreelancerDesc,
                onTap: () => controller.select(UserRole.freelancer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SetCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.heading3),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
