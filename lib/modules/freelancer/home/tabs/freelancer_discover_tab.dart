import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/set_card.dart';
import '../../../../widgets/set_hero_card.dart';
import '../../../../widgets/set_section_header.dart';

class FreelancerDiscoverTab extends StatelessWidget {
  const FreelancerDiscoverTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    final opportunities = const [
      ('NEW', 'İstanbul\'da 2 günlük reklam çekimi', '₺18.000', true),
      ('TRENDING', 'Müzik videosu prodüksiyonu', '₺40.000', false),
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
            eyebrow: 'OPPORTUNITIES',
            title: 'Keşfet',
            description: 'Sana uygun yeni işler',
            large: true,
          ),
          const SizedBox(height: AppSpacing.xl),
          SetHeroCard(
            eyebrow: 'PRO TIP',
            title: 'Portföyüne en iyi 3 işini koy',
            subtitle: 'İlk izlenim her şey. Vitrinindeki işleri seçici tut.',
            decorativeIcon: Icons.lightbulb_outline,
            tag: 'TIP',
            aspectRatio: 16 / 9,
            featured: true,
          ),
          const SizedBox(height: AppSpacing.xl),
          SetSectionHeader(eyebrow: 'JOB BOARD', title: 'Açık ilanlar'),
          const SizedBox(height: AppSpacing.lg),
          ...opportunities.map((o) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _JobCard(
                category: o.$1,
                title: o.$2,
                budget: o.$3,
                isNew: o.$4,
                secondaryColor: secondaryColor,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  const _JobCard({
    required this.category,
    required this.title,
    required this.budget,
    required this.isNew,
    required this.secondaryColor,
  });

  final String category;
  final String title;
  final String budget;
  final bool isNew;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SetCard(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: AppTextStyles.eyebrow.copyWith(
                  color: isNew ? AppColors.accentCyan : AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(title, style: AppTextStyles.heading3),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(
                    Icons.payments_outlined,
                    size: 18,
                    color: secondaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(budget, style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
                ],
              ),
            ],
          ),
        ),
        if (isNew)
          Positioned(
            left: 0,
            top: 12,
            bottom: 12,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: AppColors.accentCyan,
                borderRadius: BorderRadius.circular(AppRadius.full),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: 0.6),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
