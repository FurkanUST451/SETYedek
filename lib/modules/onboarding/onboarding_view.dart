import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'onboarding_controller.dart';

// Warm gold tone — matches the cinematic photo accents.
const Color _cinematicGold = Color(0xFFD9B36A);
const Color _cinematicCream = Color(0xFFE8D8B8);
// Deep warm black — readable on the cream button background.
const Color _cinematicInk = Color(0xFF1A1410);

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Per-page full-bleed background layer.
          Positioned.fill(
            child: Obx(() {
              final bg = OnboardingController
                  .pages[controller.currentPage.value].backgroundImage;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: bg != null
                    ? Image.asset(
                        bg,
                        key: ValueKey(bg),
                        fit: BoxFit.cover,
                      )
                    : const SizedBox.shrink(key: ValueKey('no-bg')),
              );
            }),
          ),
          // Foreground UI
          SafeArea(
            child: Column(
              children: [
                _TopBar(onSkip: controller.skip),
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: OnboardingController.pages.length,
                    itemBuilder: (_, i) =>
                        _CinematicPage(data: OnboardingController.pages[i]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  child: Column(
                    children: [
                      Obx(() => _ProgressBars(
                            count: OnboardingController.pages.length,
                            activeIndex: controller.currentPage.value,
                          )),
                      Obx(() => Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.lg),
                            child: _CinematicButton(
                              text: controller.isLastPage
                                  ? 'Başla'
                                  : AppStrings.continueLabel,
                              onPressed: controller.next,
                            ),
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.md,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.appName,
            style: AppTextStyles.wordmark.copyWith(
              fontSize: 20,
              letterSpacing: 4,
              color: _cinematicCream,
            ),
          ),
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              foregroundColor: _cinematicCream,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            child: Text(
              'Atla',
              style: AppTextStyles.button.copyWith(
                color: _cinematicCream,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CinematicPage extends StatelessWidget {
  const _CinematicPage({required this.data});

  final OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            style: AppTextStyles.editorialDisplay.copyWith(
              color: _cinematicCream,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            data.subtitle,
            style: AppTextStyles.body1.copyWith(
              color: _cinematicCream.withValues(alpha: 0.78),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _CinematicButton extends StatelessWidget {
  const _CinematicButton({
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.full);
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _cinematicCream,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: _cinematicCream.withValues(alpha: 0.3),
              blurRadius: 28,
              offset: const Offset(0, 10),
              spreadRadius: -6,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            splashColor: _cinematicGold.withValues(alpha: 0.3),
            highlightColor: _cinematicGold.withValues(alpha: 0.15),
            child: Center(
              child: Text(
                text,
                style: AppTextStyles.button.copyWith(
                  color: _cinematicInk,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressBars extends StatelessWidget {
  const _ProgressBars({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 44,
          height: 3,
          decoration: BoxDecoration(
            color: active
                ? _cinematicGold
                : _cinematicCream.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(AppRadius.full),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: _cinematicGold.withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
