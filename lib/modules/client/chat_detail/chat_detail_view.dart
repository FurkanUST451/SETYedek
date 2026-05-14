import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/set_avatar.dart';
import '../../../widgets/set_glass_app_bar.dart';
import 'chat_detail_controller.dart';

class ChatDetailView extends GetView<ChatDetailController> {
  const ChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: SetGlassAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: Get.back,
        ),
        title: controller.chatName,
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: secondaryColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    MediaQuery.of(context).padding.top + 72,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  itemCount: controller.messages.length,
                  itemBuilder: (_, i) {
                    final msg = controller.messages[i];
                    final mine = i.isOdd;
                    return _MessageBubble(
                      message: msg,
                      mine: mine,
                      name: controller.chatName,
                    );
                  },
                )),
          ),
          _Composer(controller: controller),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.mine,
    required this.name,
  });

  final String message;
  final bool mine;
  final String name;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theirBg = isDark
        ? AppColors.surfaceDarkElevated
        : AppColors.surfaceLightElevated;
    final theirText =
        isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final borderColor = (isDark ? AppColors.border : AppColors.borderLight)
        .withValues(alpha: 0.6);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            mine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!mine) ...[
            SetAvatar(name: name, size: 28, ring: false),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm + 2,
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              decoration: BoxDecoration(
                gradient: mine
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.primaryDeep,
                        ],
                      )
                    : null,
                color: mine ? null : theirBg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(mine ? 20 : 6),
                  bottomRight: Radius.circular(mine ? 6 : 20),
                ),
                border: mine
                    ? null
                    : Border.all(color: borderColor, width: 0.5),
                boxShadow: mine
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                          spreadRadius: -2,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                message,
                style: AppTextStyles.body1.copyWith(
                  color: mine ? Colors.white : theirText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller});

  final ChatDetailController controller;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = (isDark ? AppColors.surfaceDarkElevated : AppColors.surfaceLight)
        .withValues(alpha: isDark ? 0.75 : 0.92);
    final borderColor = (isDark ? AppColors.border : AppColors.borderLight)
        .withValues(alpha: 0.6);
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final hintColor =
        isDark ? AppColors.textTertiary : AppColors.textTertiaryLight;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(color: borderColor, width: 0.5),
              ),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                4,
                4,
                4,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      style: AppTextStyles.body1.copyWith(color: textColor),
                      cursorColor: AppColors.primary,
                      decoration: InputDecoration(
                        hintText: 'Mesaj yaz...',
                        hintStyle:
                            AppTextStyles.body1.copyWith(color: hintColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm + 2,
                        ),
                        isCollapsed: true,
                      ),
                      onSubmitted: (_) => controller.send(),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.primaryDeep],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 16,
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: controller.send,
                      icon: const Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
