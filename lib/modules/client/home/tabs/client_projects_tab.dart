import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/set_section_header.dart';

class ClientProjectsTab extends StatelessWidget {
  const ClientProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SetSectionHeader(
              eyebrow: 'PROJECTS',
              title: 'Projelerim',
              description: 'Açtığın projeleri ve tekliflerini buradan takip et.',
              large: true,
            ),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Icon(
                      Icons.folder_open_rounded,
                      size: 44,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Henüz projen yok',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Ana sayfadan yeni proje başlatabilirsin.',
                    style: AppTextStyles.body2.copyWith(color: secondaryColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
