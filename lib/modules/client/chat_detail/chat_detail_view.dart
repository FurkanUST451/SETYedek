import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/message_model.dart';
import 'chat_detail_controller.dart';

class ChatDetailView extends GetView<ChatDetailController> {
  const ChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => controller.goBack(),
      child: Scaffold(
        backgroundColor: const Color(0xFF141210),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: Obx(() => ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      AppSpacing.sm,
                    ),
                    itemCount: controller.messages.length + 1,
                    itemBuilder: (_, i) {
                      if (i == 0) {
                        return _BriefCard(title: controller.briefTitle);
                      }
                      final msg = controller.messages[i - 1];
                      return _buildMessage(msg);
                    },
                  )),
            ),
            _Composer(controller: controller),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF141210),
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new,
            size: 18, color: AppColors.textPrimary),
        onPressed: controller.goBack,
      ),
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF3A2D1B), Color(0xFF5C4A2D)],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              controller.chatName
                  .split(' ')
                  .map((w) => w.isNotEmpty ? w[0] : '')
                  .take(2)
                  .join()
                  .toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(controller.chatName,
                  style: AppTextStyles.body1
                      .copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(MessageModel msg) {
    final isMe = msg.senderId == controller.myId;
    final time = controller.formatTime(msg.createdAt);
    if (isMe) {
      return _MyBubble(text: msg.content, time: time);
    }
    return _TheirBubble(
      text: msg.content,
      time: time,
      initials: controller.chatName
          .split(' ')
          .map((w) => w.isNotEmpty ? w[0] : '')
          .take(2)
          .join()
          .toUpperCase(),
    );
  }
}

// ─── Brief Card ───────────────────────────────────────────────────────────────

class _BriefCard extends StatelessWidget {
  const _BriefCard({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) return const SizedBox(height: AppSpacing.sm);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1A14),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: const Color(0xFF2E2820)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.work_outline_rounded,
                color: AppColors.accentGold, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Brief',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textPrimary, fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Their text bubble ────────────────────────────────────────────────────────

class _TheirBubble extends StatelessWidget {
  const _TheirBubble(
      {required this.text, required this.time, required this.initials});
  final String text;
  final String time;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF3A2D1B), Color(0xFF5C4A2D)],
              ),
            ),
            alignment: Alignment.center,
            child: Text(initials,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700)),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.68,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1A14),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(18),
                    ),
                    border: Border.all(color: const Color(0xFF2E2820)),
                  ),
                  child: Text(text,
                      style: AppTextStyles.body1
                          .copyWith(color: AppColors.textPrimary)),
                ),
                const SizedBox(height: 3),
                Text(time,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textTertiary, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── My bubble ────────────────────────────────────────────────────────────────

class _MyBubble extends StatelessWidget {
  const _MyBubble({required this.text, required this.time});
  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.68,
              ),
              decoration: BoxDecoration(
                color: AppColors.accentGold,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                text,
                style: AppTextStyles.body1.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(time,
                    style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary, fontSize: 10)),
                const SizedBox(width: 4),
                const Icon(Icons.done_all_rounded,
                    size: 13, color: AppColors.accentGold),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Composer ─────────────────────────────────────────────────────────────────

class _Composer extends StatelessWidget {
  const _Composer({required this.controller});
  final ChatDetailController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
        color: const Color(0xFF141210),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1A14),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(color: const Color(0xFF2E2820)),
                ),
                child: TextField(
                  controller: controller.messageController,
                  style: AppTextStyles.body1
                      .copyWith(color: AppColors.textPrimary),
                  cursorColor: AppColors.accentGold,
                  decoration: InputDecoration(
                    hintText: 'Mesaj yaz...',
                    hintStyle: AppTextStyles.body1
                        .copyWith(color: AppColors.textTertiary),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10),
                    isCollapsed: true,
                  ),
                  onSubmitted: (_) => controller.send(),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Obx(() => _SendBtn(
                  onTap: controller.send,
                  isLoading: controller.isSending.value,
                )),
          ],
        ),
      ),
    );
  }
}

class _SendBtn extends StatelessWidget {
  const _SendBtn({required this.onTap, required this.isLoading});
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accentGold,
        ),
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.black),
              )
            : const Icon(Icons.send_rounded, size: 20, color: Colors.black),
      ),
    );
  }
}
