import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'category_picker_controller.dart';

class CategoryPickerView extends GetView<CategoryPickerController> {
  const CategoryPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service Category\nSelection',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Avoid boring lists to elements.',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: GridView.builder(
                  itemCount: controller.categories.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (_, i) {
                    final cat = controller.categories[i];
                    return _CinematicCard(
                      label: cat,
                      gradient: _gradientFor(cat),
                      icon: _iconFor(cat),
                      onTap: () => controller.selectCategory(cat),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _gradientFor(String category) {
    switch (category) {
      case 'Videographer':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B2A), Color(0xFF1B3A5C)],
        );
      case 'Sound Design':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A0D2E), Color(0xFF3D1F6E)],
        );
      case 'Video Edit':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0E1C1A), Color(0xFF183B35)],
        );
      case 'AI/CGI':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C1200), Color(0xFF3D2A00)],
        );
      case 'Drone':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF081820), Color(0xFF0D3040)],
        );
      case 'Photographer':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1000), Color(0xFF2E1F00)],
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF151B23), Color(0xFF1B232C)],
        );
    }
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

class _CinematicCard extends StatelessWidget {
  const _CinematicCard({
    required this.label,
    required this.gradient,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final LinearGradient gradient;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg);
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: radius,
          ),
          child: Stack(
            children: [
              // Large decorative icon fills upper portion
              Positioned(
                top: -10,
                right: -10,
                child: Icon(
                  icon,
                  size: 120,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              // Centered icon — clearer, medium size
              Positioned(
                top: 28,
                left: 0,
                right: 0,
                child: Icon(
                  icon,
                  size: 52,
                  color: Colors.white.withValues(alpha: 0.55),
                ),
              ),
              // Bottom gradient overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.4, 1.0],
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.65),
                      ],
                    ),
                  ),
                ),
              ),
              // Label at bottom left
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Text(
                  label,
                  style: AppTextStyles.heading3.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
