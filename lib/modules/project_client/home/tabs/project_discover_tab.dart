import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/set_card.dart';

class ProjectDiscoverTab extends StatelessWidget {
  const ProjectDiscoverTab({super.key});

  @override
  Widget build(BuildContext context) {
    final reels = const [
      'Volkan Otomotiv - Marka Filmi',
      'Yıldız Kahve - Reklam',
      'Aydın Hospital - Tanıtım',
      'Ayza - Müzik Videosu',
    ];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Text('SET\'in işleri', style: AppTextStyles.heading1),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Önceki prodüksiyonlarımızdan örnekler.',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...reels.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: SetCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDarkElevated,
                          borderRadius:
                              BorderRadius.circular(AppRadius.md),
                        ),
                        child: const Center(
                          child: Icon(Icons.play_circle_outline,
                              size: 48, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(r, style: AppTextStyles.heading3),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
