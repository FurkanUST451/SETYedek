import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/freelancer_model.dart';
import '../../../data/models/user_model.dart';
import '../../../widgets/set_avatar.dart';
import '../../../widgets/set_card.dart';
import '../../../widgets/set_section_header.dart';
import 'freelancers_by_category_controller.dart';

class FreelancersByCategoryView
    extends GetView<FreelancersByCategoryController> {
  const FreelancersByCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final list = controller.freelancers;

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
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentCyan
                        .withValues(alpha: isDark ? 0.18 : 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: list.isEmpty
                ? _EmptyState(category: controller.category)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.xxl,
                    ),
                    children: [
                      SetSectionHeader(
                        eyebrow: 'CATEGORY',
                        title: controller.category,
                        description:
                            'Bu alanda öne çıkan ${list.length} freelancer.',
                        large: true,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      ...list.map((f) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppSpacing.md),
                            child: _FreelancerTile(
                              freelancer: f,
                              user: controller.userFor(f),
                              secondaryColor: secondaryColor,
                              onTap: () => controller.openDetail(f),
                            ),
                          )),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _FreelancerTile extends StatelessWidget {
  const _FreelancerTile({
    required this.freelancer,
    required this.user,
    required this.secondaryColor,
    required this.onTap,
  });

  final FreelancerModel freelancer;
  final UserModel user;
  final Color secondaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SetCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: onTap,
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
                  style: AppTextStyles.body2.copyWith(color: secondaryColor),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: AppColors.accentCyan,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      freelancer.rating.toStringAsFixed(1),
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: secondaryColor,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '${freelancer.experience} yıl deneyim',
                      style: AppTextStyles.caption.copyWith(
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: secondaryColor, size: 22),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: secondaryColor,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '"$category" alanında henüz freelancer yok',
              style: AppTextStyles.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Yakında bu alanda da seçenekler olacak.',
              style: AppTextStyles.body2.copyWith(color: secondaryColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
