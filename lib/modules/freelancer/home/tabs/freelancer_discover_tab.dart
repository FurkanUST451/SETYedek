import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/set_card.dart';

class FreelancerDiscoverTab extends StatelessWidget {
  const FreelancerDiscoverTab({super.key});

  @override
  Widget build(BuildContext context) {
    final feed = const [
      ('Yeni iş', 'İstanbul\'da 2 günlük reklam çekimi · ₺18.000'),
      ('Trend', 'Müzik videosu prodüksiyonu · ₺40.000'),
      ('İpucu', 'Portföyüne en iyi 3 işini koy.'),
    ];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Text('Keşfet', style: AppTextStyles.heading1),
          const SizedBox(height: AppSpacing.lg),
          ...feed.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: SetCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(f.$1, style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text(f.$2, style: AppTextStyles.body1),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
