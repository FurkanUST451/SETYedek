import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/set_card.dart';
import '../../../../widgets/set_chip.dart';
import '../../../../widgets/set_section_header.dart';

class FreelancerChatTab extends StatelessWidget {
  const FreelancerChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final offers = const [
      ('Burcu - Marka Filmi', '₺25.000', 'Beklemede', true),
      ('Erkan - Ürün Reklamı', '₺12.000', 'Kabul Edildi', false),
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
            eyebrow: 'INBOX',
            title: 'Teklifler & Mesajlar',
            large: true,
          ),
          const SizedBox(height: AppSpacing.xl),
          ...offers.map((o) {
            final title = o.$1;
            final amount = o.$2;
            final status = o.$3;
            final pending = o.$4;
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
                        SetChip(label: status, selected: !pending),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Text(
                          'OFFER',
                          style: AppTextStyles.eyebrow.copyWith(
                            color: secondaryColor,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          amount,
                          style: AppTextStyles.heading2.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
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
