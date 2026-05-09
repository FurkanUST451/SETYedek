import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/set_avatar.dart';
import '../../../../widgets/set_card.dart';

class ClientChatTab extends StatelessWidget {
  const ClientChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final mockChats = const [
      ('Aylin Demir', 'Tamamdır, yarın detayları konuşalım.'),
      ('Mert Kaya', 'Brief\'i aldım, bu akşam bir taslak atarım.'),
      ('Selin Acar', 'Teklifin için teşekkürler!'),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Text('Mesajlar', style: AppTextStyles.heading1),
          const SizedBox(height: AppSpacing.lg),
          ...mockChats.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: SetCard(
                  onTap: () => Get.toNamed(
                    AppRoutes.chatDetail,
                    arguments: {'name': c.$1},
                  ),
                  child: Row(
                    children: [
                      SetAvatar(name: c.$1),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.$1, style: AppTextStyles.heading3),
                            const SizedBox(height: 2),
                            Text(
                              c.$2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
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
