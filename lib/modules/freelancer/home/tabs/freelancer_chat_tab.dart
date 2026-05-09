import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/set_card.dart';

class FreelancerChatTab extends StatelessWidget {
  const FreelancerChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final offers = const [
      ('Burcu - Marka Filmi', '₺25.000', 'Beklemede'),
      ('Erkan - Ürün Reklamı', '₺12.000', 'Kabul Edildi'),
    ];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Text('Teklifler & Mesajlar', style: AppTextStyles.heading1),
          const SizedBox(height: AppSpacing.lg),
          ...offers.map((o) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: SetCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(o.$1, style: AppTextStyles.heading3),
                            const SizedBox(height: 4),
                            Text(
                              o.$3,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        o.$2,
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.primary,
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
