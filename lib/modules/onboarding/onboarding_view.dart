import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/set_button.dart';
import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background radial blue glow
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 360,
              height: 360,
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
          Positioned(
            bottom: -160,
            left: -120,
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentCyan.withValues(alpha: isDark ? 0.14 : 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: TextButton(
                      onPressed: controller.skip,
                      child: Text(
                        'Atla',
                        style: AppTextStyles.button.copyWith(
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: OnboardingController.pages.length,
                    itemBuilder: (_, i) =>
                        _OnboardingPage(data: OnboardingController.pages[i]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      Obx(() => _ProgressLine(
                            count: OnboardingController.pages.length,
                            activeIndex: controller.currentPage.value,
                          )),
                      const SizedBox(height: AppSpacing.xl),
                      Obx(() => SetButton(
                            text: controller.isLastPage
                                ? 'Başla'
                                : AppStrings.continueLabel,
                            onPressed: controller.next,
                            size: SetButtonSize.hero,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stacked decorative circles + icon
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.18),
                      AppColors.accentCyan.withValues(alpha: 0.08),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 60,
                      spreadRadius: -10,
                    ),
                  ],
                ),
              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.surfaceDarkElevated
                      : AppColors.surfaceLightElevated,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    width: 0.5,
                  ),
                ),
                child: Icon(data.icon, size: 56, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'CHAPTER',
            style: AppTextStyles.eyebrow.copyWith(
              color: AppColors.accentCyan,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(data.title, style: AppTextStyles.displayXL),
          const SizedBox(height: AppSpacing.md),
          Text(
            data.subtitle,
            style: AppTextStyles.body1.copyWith(color: secondaryColor),
          ),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = isDark ? AppColors.border : AppColors.borderLight;

    return Row(
      children: List.generate(count, (i) {
        final active = i == activeIndex;
        final past = i < activeIndex;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 2,
            decoration: BoxDecoration(
              color: active || past ? AppColors.primary : inactiveColor,
              borderRadius: BorderRadius.circular(AppRadius.full),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
