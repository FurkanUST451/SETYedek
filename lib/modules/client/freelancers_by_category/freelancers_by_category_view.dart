import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/freelancer_model.dart';
import '../../../data/models/user_model.dart';
import 'freelancers_by_category_controller.dart';

class FreelancersByCategoryView
    extends GetView<FreelancersByCategoryController> {
  const FreelancersByCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final list = controller.freelancers;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.textPrimary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Choose Your\nCreative Partner',
                          style: AppTextStyles.heading1
                              .copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${list.length * 20}+ creatives available',
                          style: AppTextStyles.body2
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDarkElevated,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.tune_rounded,
                        color: AppColors.textPrimary, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // List
            Expanded(
              child: list.isEmpty
                  ? _EmptyState(category: controller.category)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxl),
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (_, i) {
                        final f = list[i];
                        return _FreelancerCard(
                          freelancer: f,
                          user: controller.userFor(f),
                          onTap: () => controller.openDetail(f),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FreelancerCard extends StatelessWidget {
  const _FreelancerCard({
    required this.freelancer,
    required this.user,
    required this.onTap,
  });

  final FreelancerModel freelancer;
  final UserModel user;
  final VoidCallback onTap;

  String _priceRange() {
    final exp = freelancer.experience;
    if (exp <= 2) return '\$1K - \$3K';
    if (exp <= 4) return '\$2K - \$5K';
    if (exp <= 6) return '\$3K - \$8K';
    if (exp <= 8) return '\$5K - \$15K';
    return '\$8K - \$20K';
  }

  // Deterministic gradient colors per freelancer for portfolio thumbnails
  List<List<Color>> _thumbGradients() {
    final seed = freelancer.userId.codeUnits.fold(0, (a, b) => a + b);
    final palettes = [
      [const Color(0xFF1A3A5C), const Color(0xFF2D6A8A)],
      [const Color(0xFF2D1B4E), const Color(0xFF5C3A8A)],
      [const Color(0xFF1B3A2D), const Color(0xFF2D6A4E)],
      [const Color(0xFF3A2D1B), const Color(0xFF8A6A2D)],
      [const Color(0xFF1B2D3A), const Color(0xFF2D5C6A)],
      [const Color(0xFF3A1B2D), const Color(0xFF6A2D5C)],
    ];
    return [
      palettes[seed % palettes.length],
      palettes[(seed + 2) % palettes.length],
      palettes[(seed + 4) % palettes.length],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final thumbGrads = _thumbGradients();
    final initials = user.name
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0] : '')
        .take(2)
        .join();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.4),
                        AppColors.accentCyan.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Name + role + rating + price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name,
                          style: AppTextStyles.heading3
                              .copyWith(fontSize: 17)),
                      const SizedBox(height: 2),
                      Text(
                        freelancer.category,
                        style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 15, color: AppColors.accentGold),
                          const SizedBox(width: 3),
                          Text(
                            freelancer.rating.toStringAsFixed(1),
                            style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          const Icon(Icons.location_on_outlined,
                              size: 13, color: AppColors.textSecondary),
                          const SizedBox(width: 2),
                          Text(
                            _priceRange(),
                            style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Portfolio thumbnails
            Row(
              children: List.generate(3, (i) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                    height: 62,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: thumbGrads[i],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded,
              size: 56, color: AppColors.textSecondary),
          const SizedBox(height: AppSpacing.md),
          Text(
            '"$category" alanında henüz\nfreelancer yok',
            style: AppTextStyles.heading3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Yakında bu alanda da seçenekler olacak.',
            style:
                AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
