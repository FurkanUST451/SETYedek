import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/set_section_header.dart';
import 'category_picker_controller.dart';

class CategoryPickerView extends GetView<CategoryPickerController> {
  const CategoryPickerView({super.key});

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
            left: -80,
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
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              children: [
                SetSectionHeader(
                  eyebrow: 'NEW PROJECT',
                  title: 'Hangi alanda çalışacaksın?',
                  description:
                      'Bir kategori seç, sana o alandaki freelancer\'ları gösterelim.',
                  large: true,
                ),
                const SizedBox(height: AppSpacing.xl),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.categories.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (_, i) {
                    final cat = controller.categories[i];
                    return _CategoryCard(
                      label: cat,
                      icon: _iconFor(cat),
                      onTap: () => controller.selectCategory(cat),
                      secondaryColor: secondaryColor,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String category) {
    switch (category) {
      case 'Videographer':
        return Icons.videocam_outlined;
      case 'Sound Design':
        return Icons.graphic_eq_rounded;
      case 'Video Edit':
        return Icons.movie_filter_outlined;
      case 'AI/CGI':
        return Icons.auto_awesome_outlined;
      case 'Drone':
        return Icons.flight_takeoff_rounded;
      case 'Photographer':
        return Icons.camera_alt_outlined;
      default:
        return Icons.work_outline;
    }
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.secondaryColor,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(AppRadius.lg);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: radius,
            color: isDark
                ? AppColors.surfaceDarkElevated
                : AppColors.surfaceLightElevated,
            border: Border.all(
              color: (isDark ? AppColors.border : AppColors.borderLight)
                  .withValues(alpha: 0.7),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.12),
                blurRadius: 20,
                spreadRadius: -6,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.3),
                      AppColors.accentCyan.withValues(alpha: 0.15),
                    ],
                  ),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.heading3.copyWith(fontSize: 17),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'Keşfet',
                        style: AppTextStyles.caption.copyWith(
                          color: secondaryColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: secondaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
