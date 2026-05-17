import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
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
                    if (i == 0) return const _ActiveProjectCard();
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
          // Avatar
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
                  .join(),
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
              Text('Director',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.phone_outlined,
              color: AppColors.textSecondary, size: 20),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.videocam_outlined,
              color: AppColors.textSecondary, size: 22),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMessage(ChatMsg msg) {
    switch (msg.type) {
      case ChatMsgType.text:
        return _TheirBubble(text: msg.text ?? '', time: msg.time);
      case ChatMsgType.photos:
        return _PhotoGrid(time: msg.time);
      case ChatMsgType.voice:
        return _VoiceMessage(time: msg.time);
      case ChatMsgType.mine:
        return _MyBubble(text: msg.text ?? '', time: msg.time);
    }
  }
}

// ─── Active Project Card ─────────────────────────────────────────────────────

class _ActiveProjectCard extends StatelessWidget {
  const _ActiveProjectCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1A14),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: const Color(0xFF2E2820)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Project',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Luxury Product Film',
                  style: AppTextStyles.heading3
                      .copyWith(color: AppColors.textPrimary, fontSize: 18),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(Icons.schedule_outlined,
                        size: 13, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('3 - 4 Weeks',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textSecondary)),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(Icons.attach_money_rounded,
                        size: 13, color: AppColors.textSecondary),
                    Text('\$15K - \$30K',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(
                        color: AppColors.accentGold.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    'In Progress',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.accentGold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Thumbnail placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2A2018), Color(0xFF1A1510)],
                ),
              ),
              child: const Icon(Icons.movie_outlined,
                  color: Color(0xFF4A3A28), size: 32),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Their text bubble ────────────────────────────────────────────────────────

class _TheirBubble extends StatelessWidget {
  const _TheirBubble({required this.text, required this.time});
  final String text;
  final String time;

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
            child: const Text('JP',
                style: TextStyle(
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

// ─── Photo grid ───────────────────────────────────────────────────────────────

class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({required this.time});
  final String time;

  static const _gradients = [
    [Color(0xFF2A2018), Color(0xFF4A3828)],
    [Color(0xFF1A1A1A), Color(0xFF2A2A2A)],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 36, bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(2, (i) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i == 0 ? 4 : 0),
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _gradients[i],
                    ),
                  ),
                  child: Icon(
                    i == 0
                        ? Icons.camera_alt_outlined
                        : Icons.image_outlined,
                    color: const Color(0xFF5A4A38),
                    size: 28,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 3),
          Text(time,
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textTertiary, fontSize: 10)),
        ],
      ),
    );
  }
}

// ─── Voice Message ────────────────────────────────────────────────────────────

class _VoiceMessage extends StatelessWidget {
  const _VoiceMessage({required this.time});
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 36, bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1A14),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: const Color(0xFF2E2820)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF2A2018),
                  ),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: AppColors.textPrimary, size: 20),
                ),
                const SizedBox(width: 10),
                _Waveform(),
                const SizedBox(width: 10),
                Text('0:28',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(time,
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textTertiary, fontSize: 10)),
        ],
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  final _rng = Random(42);

  _Waveform();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(28, (i) {
        final h = 8.0 + _rng.nextDouble() * 18;
        return Container(
          width: 2.5,
          height: h,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
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
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.messageController,
                        style: AppTextStyles.body1
                            .copyWith(color: AppColors.textPrimary),
                        cursorColor: AppColors.accentGold,
                        decoration: InputDecoration(
                          hintText: 'Message...',
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
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _IconBtn(icon: Icons.attach_file_rounded, onTap: () {}),
            const SizedBox(width: 6),
            _IconBtn(icon: Icons.mic_none_rounded, onTap: () {}),
            const SizedBox(width: 6),
            _IconBtn(
              icon: Icons.add_rounded,
              onTap: controller.send,
              filled: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn(
      {required this.icon, required this.onTap, this.filled = false});
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? AppColors.accentGold : const Color(0xFF1E1A14),
          border: filled
              ? null
              : Border.all(color: const Color(0xFF2E2820)),
        ),
        child: Icon(
          icon,
          size: 20,
          color: filled ? Colors.black : AppColors.textSecondary,
        ),
      ),
    );
  }
}
