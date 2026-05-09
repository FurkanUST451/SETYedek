import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/dummy/dummy_data.dart';
import '../../../../data/models/freelancer_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/set_avatar.dart';
import '../../../../widgets/set_card.dart';
import 'package:get/get.dart';

class ClientDiscoverTab extends StatelessWidget {
  const ClientDiscoverTab({super.key});

  @override
  Widget build(BuildContext context) {
    final freelancers = DummyData.freelancers;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Text('Keşfet', style: AppTextStyles.heading1),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Projelerin için doğru freelancer\'ı bul.',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _Categories(),
          const SizedBox(height: AppSpacing.lg),
          ...freelancers.map((f) {
            final user = DummyData.users.firstWhere(
              (u) => u.id == f.userId,
              orElse: () => UserModel(
                id: f.userId,
                name: 'Bilinmiyor',
                email: '',
                role: UserRole.freelancer,
                createdAt: DateTime.now(),
              ),
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _FreelancerTile(freelancer: f, user: user),
            );
          }),
        ],
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: DummyData.categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) {
          final c = DummyData.categories[i];
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceDarkElevated,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.border),
            ),
            alignment: Alignment.center,
            child: Text(c, style: AppTextStyles.body2),
          );
        },
      ),
    );
  }
}

class _FreelancerTile extends StatelessWidget {
  const _FreelancerTile({required this.freelancer, required this.user});

  final FreelancerModel freelancer;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SetCard(
      onTap: () => Get.toNamed(
        AppRoutes.freelancerDetail,
        arguments: {'freelancer': freelancer, 'user': user},
      ),
      child: Row(
        children: [
          SetAvatar(name: user.name, size: 56),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: AppTextStyles.heading3),
                const SizedBox(height: 2),
                Text(
                  '${freelancer.category} · ${freelancer.location}',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      freelancer.rating.toStringAsFixed(1),
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '${freelancer.experience} yıl',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
