import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

enum SetButtonVariant { primary, secondary, outline }

enum SetButtonSize { regular, hero }

class SetButton extends StatelessWidget {
  const SetButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = SetButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
    this.size = SetButtonSize.regular,
  });

  final String text;
  final VoidCallback? onPressed;
  final SetButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  final SetButtonSize size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = _styleFor(variant, isDark);
    final disabled = onPressed == null || isLoading;
    final height = size == SetButtonSize.hero ? 60.0 : 52.0;
    final fontSize = size == SetButtonSize.hero ? 17.0 : 15.0;
    final radius = BorderRadius.circular(AppRadius.full);

    final loadingColor = variant == SetButtonVariant.primary
        ? AppColors.accentCyan
        : AppColors.primary;

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation(loadingColor),
            ),
          )
        : Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: config.foreground),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                text,
                style: AppTextStyles.button.copyWith(
                  color: config.foreground,
                  fontSize: fontSize,
                ),
              ),
            ],
          );

    final inkwell = Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: disabled ? null : onPressed,
        borderRadius: radius,
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          alignment: Alignment.center,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: disabled && !isLoading ? 0.55 : 1,
            child: child,
          ),
        ),
      ),
    );

    final container = Container(
      decoration: BoxDecoration(
        gradient: config.gradient,
        color: config.gradient == null ? config.background : null,
        borderRadius: radius,
        border: config.borderColor != null
            ? Border.all(color: config.borderColor!, width: 1)
            : null,
        boxShadow: config.shadow,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: inkwell,
      ),
    );

    return fullWidth
        ? SizedBox(width: double.infinity, child: container)
        : container;
  }

  _SetButtonStyle _styleFor(SetButtonVariant v, bool isDark) {
    switch (v) {
      case SetButtonVariant.primary:
        return _SetButtonStyle(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDeep],
          ),
          foreground: Colors.white,
          shadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
          ],
        );
      case SetButtonVariant.secondary:
        return _SetButtonStyle(
          background: isDark
              ? AppColors.surfaceDarkElevated
              : AppColors.surfaceLightElevated,
          foreground: isDark
              ? AppColors.textPrimary
              : AppColors.textPrimaryLight,
          borderColor:
              (isDark ? AppColors.border : AppColors.borderLight)
                  .withValues(alpha: 0.6),
        );
      case SetButtonVariant.outline:
        return _SetButtonStyle(
          background: AppColors.transparent,
          foreground: isDark
              ? AppColors.textPrimary
              : AppColors.textPrimaryLight,
          borderColor: isDark
              ? AppColors.borderStrong
              : AppColors.borderLightStrong,
        );
    }
  }
}

class _SetButtonStyle {
  const _SetButtonStyle({
    this.gradient,
    this.background = AppColors.transparent,
    required this.foreground,
    this.borderColor,
    this.shadow,
  });

  final Gradient? gradient;
  final Color background;
  final Color foreground;
  final Color? borderColor;
  final List<BoxShadow>? shadow;
}
