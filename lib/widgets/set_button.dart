import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

enum SetButtonVariant { primary, secondary, outline }

class SetButton extends StatelessWidget {
  const SetButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = SetButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
  });

  final String text;
  final VoidCallback? onPressed;
  final SetButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = _styleFor(variant, isDark);
    final disabled = onPressed == null || isLoading;

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation(config.foreground),
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
                style: AppTextStyles.button.copyWith(color: config.foreground),
              ),
            ],
          );

    final button = Material(
      color: config.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: config.borderColor != null
            ? BorderSide(color: config.borderColor!)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: disabled ? null : onPressed,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          height: 52,
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

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }

  _SetButtonStyle _styleFor(SetButtonVariant v, bool isDark) {
    switch (v) {
      case SetButtonVariant.primary:
        return const _SetButtonStyle(
          background: AppColors.primary,
          foreground: AppColors.textPrimary,
        );
      case SetButtonVariant.secondary:
        return _SetButtonStyle(
          background: isDark
              ? AppColors.surfaceDarkElevated
              : AppColors.surfaceLightElevated,
          foreground: isDark
              ? AppColors.textPrimary
              : AppColors.textPrimaryLight,
        );
      case SetButtonVariant.outline:
        return _SetButtonStyle(
          background: AppColors.transparent,
          foreground: isDark
              ? AppColors.textPrimary
              : AppColors.textPrimaryLight,
          borderColor: isDark ? AppColors.border : AppColors.borderLight,
        );
    }
  }
}

class _SetButtonStyle {
  const _SetButtonStyle({
    required this.background,
    required this.foreground,
    this.borderColor,
  });

  final Color background;
  final Color foreground;
  final Color? borderColor;
}
