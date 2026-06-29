import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../modules/app/user_controller.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/set_avatar.dart';
import '../../../../widgets/set_card.dart';
import '../../../../widgets/set_section_header.dart';
import '../freelancer_chats_controller.dart';

class FreelancerChatTab extends StatelessWidget {
  const FreelancerChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FreelancerChatsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final myId =
        Get.find<UserController>().currentUser?.id ?? '';

    return SafeArea(
      bottom: false,
      child: Obx(() {
        final chats = controller.chats;
        return ListView(
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
            if (chats.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Text(
                    'Henüz mesajın yok.\nBir teklifi kabul edip mesajlaşmaya başla.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body2
                        .copyWith(color: secondaryColor),
                  ),
                ),
              )
            else
              ...chats.map((chat) {
                final name = chat.otherUserName(myId);
                final snippet = chat.lastMessage ?? '';
                final time = chat.lastMessageAt != null
                    ? _fmtTime(chat.lastMessageAt!)
                    : '';
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: SetCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    onTap: () => Get.toNamed(
                      AppRoutes.chatDetail,
                      arguments: {
                        'chatId': chat.id,
                        'otherUserName': name,
                        'briefTitle': chat.briefTitle,
                        'returnRoute': AppRoutes.freelancerHome,
                      },
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
                                      style: AppTextStyles.heading3
                                          .copyWith(fontSize: 17),
                                    ),
                                  ),
                                  Text(
                                    time,
                                    style: AppTextStyles.caption
                                        .copyWith(color: secondaryColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                snippet.isNotEmpty
                                    ? snippet
                                    : chat.briefTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.body2
                                    .copyWith(color: secondaryColor),
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
        );
      }),
    );
  }

  static const _months = [
    '', 'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
    'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
  ];

  String _fmtTime(DateTime dt) {
    final now = DateTime.now();
    if (dt.year == now.year &&
        dt.month == now.month &&
        dt.day == now.day) {
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final p = dt.hour >= 12 ? 'PM' : 'AM';
      return '$h:$m $p';
    }
    return '${dt.day} ${_months[dt.month]}';
  }
}
