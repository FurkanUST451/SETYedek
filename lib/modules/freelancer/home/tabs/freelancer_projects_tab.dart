import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/set_card.dart';

class FreelancerProjectsTab extends StatelessWidget {
  const FreelancerProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = const [
      ('Ürün Reklamı - Erkan', 'Aktif', '12 Mayıs teslim'),
      ('Müzik Videosu - Aria', 'Tamamlandı', '04 Mart'),
    ];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Text('Projelerim', style: AppTextStyles.heading1),
          const SizedBox(height: AppSpacing.lg),
          ...projects.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: SetCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.$1, style: AppTextStyles.heading3),
                      const SizedBox(height: 4),
                      Text(
                        '${p.$2} · ${p.$3}',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
