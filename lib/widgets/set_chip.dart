import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_text_styles.dart';

class SetChip extends StatelessWidget {
  const SetChip({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
    this.color,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark
        ? AppColors.surfaceDarkElevated.withValues(alpha: 0.7)
        : AppColors.surfaceLightElevated;
    final defaultText =
        isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final defaultBorder = (isDark ? AppColors.border : AppColors.borderLight)
        .withValues(alpha: 0.6);

    final bg = selected
        ? AppColors.primary.withValues(alpha: 0.18)
        : (color ?? defaultBg);
    final textColor = selected ? AppColors.primary : defaultText;
    final borderColor = selected
        ? AppColors.primary.withValues(alpha: 0.4)
        : defaultBorder;

    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return pill;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: pill,
      ),
    );
  }
}
