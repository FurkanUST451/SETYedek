import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/set_card.dart';
import '../../../../widgets/set_chip.dart';
import '../../../../widgets/set_section_header.dart';

class FreelancerProjectsTab extends StatelessWidget {
  const FreelancerProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final projects = const [
      ('Ürün Reklamı - Erkan', 'Aktif', '12 Mayıs teslim', 'PRE-PRODUCTION', 0.45),
      ('Müzik Videosu - Aria', 'Tamamlandı', '04 Mart', 'DELIVERED', 1.0),
    ];

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          120,
        ),
        children: [
          SetSectionHeader(
            eyebrow: 'WORKSPACE',
            title: 'Projelerim',
            description: 'Aktif ve tamamlanan işler',
            large: true,
          ),
          const SizedBox(height: AppSpacing.xl),
          ...projects.map((p) {
            final title = p.$1;
            final status = p.$2;
            final date = p.$3;
            final stage = p.$4;
            final progress = p.$5;
            final active = status == 'Aktif';
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: SetCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(title, style: AppTextStyles.heading3),
                        ),
                        SetChip(
                          label: status,
                          selected: active,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: secondaryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          date,
                          style: AppTextStyles.body2.copyWith(
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Progress
                    Text(
                      stage,
                      style: AppTextStyles.eyebrow.copyWith(
                        color: active
                            ? AppColors.accentCyan
                            : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor:
                            (isDark ? AppColors.border : AppColors.borderLight),
                        valueColor: AlwaysStoppedAnimation(
                          active ? AppColors.accentCyan : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
