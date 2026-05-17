import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';

class ProjectModeView extends StatelessWidget {
  const ProjectModeView({super.key});

  void _goToChat(String mode) {
    Get.toNamed(AppRoutes.chatDetail, arguments: {'name': 'SET Support', 'mode': mode});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.xl,
              ),
              child: Text(
                'How would you\nlike to get started?',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
            ),
            // Split panels
            Expanded(
              child: Row(
                children: [
                  // Left — Hire Talent
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _goToChat('hire'),
                      child: Container(
                        color: const Color(0xFF0E0E0E),
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Hire\nTalent',
                              style: AppTextStyles.heading2.copyWith(
                                color: AppColors.textPrimary,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Find and hire creatives yourself',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Right — SET Handles It
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _goToChat('set'),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xFF5C3A00),
                              Color(0xFF2E1D00),
                              Color(0xFF1A1000),
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ),
                        ),
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'SET\nHandles It',
                              style: AppTextStyles.heading2.copyWith(
                                color: AppColors.textPrimary,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Our team manages everything for you',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white.withValues(alpha: 0.65),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            // Arrow button
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.45),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
