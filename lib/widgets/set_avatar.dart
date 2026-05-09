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
  });

  final String? imageUrl;
  final String? name;
  final double size;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final initials = (name ?? '').initials;
    final fallbackColor = AppColors.primary.withValues(alpha: 0.18);

    final container = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fallbackColor,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1.5)
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: AppTextStyles.body1.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: size * 0.36,
        ),
      ),
    );

    if (imageUrl == null || imageUrl!.isEmpty) return container;

    return ClipOval(
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
  }
}
