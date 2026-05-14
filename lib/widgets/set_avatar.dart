import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/extensions/string_extensions.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class SetAvatar extends StatelessWidget {
  const SetAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 48,
    this.borderColor,
    this.ring = true,
  });

  final String? imageUrl;
  final String? name;
  final double size;
  final Color? borderColor;
  final bool ring;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initials = (name ?? '').initials;
    final ringColor = borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.08)
            : AppColors.borderLight);

    final container = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.22),
            AppColors.accentCyan.withValues(alpha: 0.12),
          ],
        ),
        border: ring ? Border.all(color: ringColor, width: 0.5) : null,
      ),
      alignment: Alignment.center,
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: AppTextStyles.heading3.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: size * 0.36,
          height: 1,
        ),
      ),
    );

    if (imageUrl == null || imageUrl!.isEmpty) return container;

    final image = ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          fit: BoxFit.cover,
          placeholder: (_, _) => container,
          errorWidget: (_, _, _) => container,
        ),
      ),
    );

    if (!ring) return image;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor, width: 0.5),
      ),
      child: image,
    );
  }
}
