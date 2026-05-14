import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_spacing.dart';

class SetCard extends StatelessWidget {
  const SetCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.borderRadius,
    this.onTap,
    this.blur = 18,
    this.glow = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final double blur;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? BorderRadius.circular(AppRadius.lg);
    final surface = (isDark ? AppColors.surfaceDark : AppColors.surfaceLight)
        .withValues(alpha: isDark ? 0.55 : 0.85);
    final borderColor = (isDark ? AppColors.border : AppColors.borderLight)
        .withValues(alpha: 0.6);
    final highlightColor = isDark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.white.withValues(alpha: 0.6);

    final shadows = <BoxShadow>[
      BoxShadow(
        color: isDark
            ? const Color(0x66000000)
            : const Color(0x140E1419),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
      if (glow)
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.18),
          blurRadius: 32,
          spreadRadius: -4,
        ),
    ];

    final content = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: shadows,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  highlightColor,
                  Colors.transparent,
                ],
                stops: const [0, 0.4],
              ),
              color: surface,
              borderRadius: radius,
              border: Border.all(color: borderColor, width: 0.5),
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: content,
      ),
    );
  }
}
