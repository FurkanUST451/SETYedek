import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

class SetNavItem {
  const SetNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class SetBottomNav extends StatelessWidget {
  const SetBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<SetNavItem> items;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = (isDark ? AppColors.surfaceDarkElevated : AppColors.surfaceLight)
        .withValues(alpha: isDark ? 0.7 : 0.85);
    final inactive = isDark
        ? AppColors.textSecondary
        : AppColors.textSecondaryLight;
    final borderColor = (isDark ? AppColors.border : AppColors.borderLight)
        .withValues(alpha: 0.6);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? const Color(0x80000000)
                    : const Color(0x1A0E1419),
                blurRadius: 32,
                offset: const Offset(0, 16),
                spreadRadius: -4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: borderColor, width: 0.5),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                height: 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(items.length, (i) {
                    final item = items[i];
                    final selected = i == currentIndex;
                    return Expanded(
                      child: _NavItemTile(
                        item: item,
                        selected: selected,
                        inactiveColor: inactive,
                        onTap: () => onTap(i),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemTile extends StatelessWidget {
  const _NavItemTile({
    required this.item,
    required this.selected,
    required this.inactiveColor,
    required this.onTap,
  });

  final SetNavItem item;
  final bool selected;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : inactiveColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 12 : 8,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.16)
              : AppColors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 20, color: color),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: selected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        item.label,
                        style: AppTextStyles.caption.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
