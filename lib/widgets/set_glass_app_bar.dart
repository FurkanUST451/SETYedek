import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class SetGlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SetGlassAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.height = 56,
  });

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = (isDark ? AppColors.backgroundDark : AppColors.backgroundLight)
        .withValues(alpha: 0.6);
    final borderColor = (isDark ? AppColors.border : AppColors.borderLight)
        .withValues(alpha: 0.4);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            border: Border(
              bottom: BorderSide(color: borderColor, width: 0.5),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: height,
              child: NavigationToolbar(
                leading: leading,
                middle: title != null
                    ? Text(title!, style: AppTextStyles.heading3)
                    : null,
                trailing: actions != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions!,
                      )
                    : null,
                centerMiddle: centerTitle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
