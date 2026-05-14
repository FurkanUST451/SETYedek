import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryText =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.9,
            colors: isDark
                ? const [
                    Color(0xFF1B232C),
                    AppColors.backgroundDark,
                  ]
                : const [
                    Color(0xFFFFFFFF),
                    AppColors.backgroundLight,
                  ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Wordmark with soft blue glow
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 60,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  AppStrings.appName,
                  style: AppTextStyles.wordmark.copyWith(
                    color: AppColors.primary,
                    fontSize: 64,
                    letterSpacing: -2.5,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                AppStrings.appTagline,
                style: AppTextStyles.body2.copyWith(color: secondaryText),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(AppColors.accentCyan),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
