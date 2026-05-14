import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/set_avatar.dart';
import '../../../../widgets/set_card.dart';
import '../../../../widgets/set_section_header.dart';

class ClientChatTab extends StatelessWidget {
  const ClientChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final mockChats = const [
      ('Aylin Demir', 'Tamamdır, yarın detayları konuşalım.', '12:32', true),
      ('Mert Kaya', 'Brief\'i aldım, bu akşam bir taslak atarım.', '11:08', true),
      ('Selin Acar', 'Teklifin için teşekkürler!', 'Dün', false),
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
            title: 'Mesajlar',
            description: 'Aktif görüşmelerin',
            large: true,
          ),
          const SizedBox(height: AppSpacing.xl),
          ...mockChats.map((c) {
            final name = c.$1;
            final snippet = c.$2;
            final time = c.$3;
            final unread = c.$4;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: SetCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                onTap: () => Get.toNamed(
                  AppRoutes.chatDetail,
                  arguments: {'name': name},
                ),
                child: Row(
                  children: [
                    SetAvatar(name: name, size: 52),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: AppTextStyles.heading3.copyWith(
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              Text(
                                time,
                                style: AppTextStyles.caption.copyWith(
                                  color: secondaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  snippet,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.body2.copyWith(
                                    color: secondaryColor,
                                  ),
                                ),
                              ),
                              if (unread) ...[
                                const SizedBox(width: AppSpacing.sm),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.accentCyan,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.accentCyan
                                            .withValues(alpha: 0.6),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
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
