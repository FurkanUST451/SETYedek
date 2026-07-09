import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/brief_model.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/offer_model.dart';
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
                        return _BriefCard(controller: controller);
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

    if (msg.type == 'offer' && msg.offerId != null) {
      return Obx(() {
        final offer = controller.offers[msg.offerId];
        if (offer == null) {
          return const SizedBox.shrink();
        }
        return _OfferBubble(
          offer: offer,
          isMe: isMe,
          time: time,
          onAccept: () => controller.respondToOffer(offer, true),
          onReject: () => controller.respondToOffer(offer, false),
        );
      });
    }

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
  const _BriefCard({required this.controller});
  final ChatDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final brief = controller.brief.value;
      final category =
          brief?.category.isNotEmpty == true ? brief!.category : controller.briefTitle;
      final shootingType = brief?.answers.shootingType;
      if (category.isEmpty) return const SizedBox(height: AppSpacing.sm);

      return GestureDetector(
        onTap: brief == null ? null : () => _showBriefDetail(context, brief),
        child: Container(
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
                      category,
                      style: AppTextStyles.heading3.copyWith(
                          color: AppColors.textPrimary, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (shootingType != null && shootingType.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        shootingType,
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (brief != null)
                const Icon(Icons.chevron_right,
                    size: 18, color: AppColors.textTertiary),
            ],
          ),
        ),
      );
    });
  }

  void _showBriefDetail(BuildContext context, BriefModel brief) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1A14),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _BriefDetailSheet(brief: brief),
    );
  }
}

class _BriefDetailSheet extends StatelessWidget {
  const _BriefDetailSheet({required this.brief});
  final BriefModel brief;

  @override
  Widget build(BuildContext context) {
    final a = brief.answers;
    final items = <(IconData, String, String)>[
      if (a.shootingType != null && a.shootingType!.isNotEmpty)
        (Icons.movie_creation_outlined, 'Çekim Türü', a.shootingType!),
      if (a.dateRange != null && a.dateRange!.isNotEmpty)
        (Icons.calendar_today_outlined, 'Çekim Tarihi', a.dateRange!),
      if (a.deliveryTime != null && a.deliveryTime!.isNotEmpty)
        (Icons.access_time_outlined, 'Teslim Süresi', a.deliveryTime!),
      if (a.budget != null && a.budget!.isNotEmpty)
        (Icons.attach_money_outlined, 'Bütçe', a.budget!),
      if (a.location != null && a.location!.isNotEmpty)
        (Icons.location_on_outlined, 'Lokasyon', a.location!),
      if (a.vibes != null && a.vibes!.isNotEmpty)
        (Icons.show_chart_rounded, 'Duygu', a.vibes!.join(', ')),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              brief.category.isNotEmpty ? brief.category : 'İş',
              style: AppTextStyles.heading3
                  .copyWith(color: AppColors.textPrimary, fontSize: 18),
            ),
            if (a.shootingType != null && a.shootingType!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                a.shootingType!,
                style: AppTextStyles.body2
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            if (items.isNotEmpty)
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: items
                    .map((item) => _DetailChip(
                          icon: item.$1,
                          label: item.$2,
                          value: item.$3,
                        ))
                    .toList(),
              ),
            if (a.notes != null && a.notes!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                'İŞ TARİFİ',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                a.notes!,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 130),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF141210),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: const Color(0xFF2E2820)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text(label,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textTertiary, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Offer bubble ─────────────────────────────────────────────────────────────

class _OfferBubble extends StatelessWidget {
  const _OfferBubble({
    required this.offer,
    required this.isMe,
    required this.time,
    required this.onAccept,
    required this.onReject,
  });

  final OfferModel offer;
  final bool isMe;
  final String time;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  String get _statusLabel {
    switch (offer.status) {
      case OfferStatus.accepted:
        return 'Kabul Edildi';
      case OfferStatus.rejected:
        return 'Reddedildi';
      case OfferStatus.pending:
        return isMe ? 'Yanıt Bekleniyor' : 'Yanıt Bekliyor';
    }
  }

  Color get _statusColor {
    switch (offer.status) {
      case OfferStatus.accepted:
        return const Color(0xFF2E7D32);
      case OfferStatus.rejected:
        return const Color(0xFFD32F2F);
      case OfferStatus.pending:
        return AppColors.accentGold;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1A14),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.payments_outlined,
                      size: 18, color: AppColors.accentGold),
                  const SizedBox(width: 6),
                  Text('Fiyat Teklifi',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textSecondary)),
                  const Spacer(),
                  Text(
                    _statusLabel,
                    style: AppTextStyles.caption.copyWith(
                      color: _statusColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${offer.amount.toStringAsFixed(0)} ₺',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (offer.message.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(offer.message,
                    style: AppTextStyles.body2
                        .copyWith(color: AppColors.textSecondary)),
              ],
              if (!isMe && offer.status == OfferStatus.pending) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onReject,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFD32F2F),
                          side: const BorderSide(color: Color(0xFFD32F2F)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text('Reddet'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onAccept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGold,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text('Kabul Et'),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 4),
              Text(time,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textTertiary, fontSize: 10)),
            ],
          ),
        ),
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
            GestureDetector(
              onTap: () => _showOfferSheet(context, controller),
              child: Container(
                width: 44,
                height: 44,
                margin: const EdgeInsets.only(right: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1A14),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2E2820)),
                ),
                child: const Icon(Icons.payments_outlined,
                    size: 20, color: AppColors.accentGold),
              ),
            ),
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

void _showOfferSheet(BuildContext context, ChatDetailController controller) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1E1A14),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fiyat Teklifi Gönder',
                style: AppTextStyles.heading3
                    .copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: controller.offerAmountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
              cursorColor: AppColors.accentGold,
              decoration: InputDecoration(
                hintText: 'Tutar (₺)',
                hintStyle: AppTextStyles.body1.copyWith(color: AppColors.textTertiary),
                filled: true,
                fillColor: const Color(0xFF141210),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: controller.offerNoteController,
              maxLines: 2,
              style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
              cursorColor: AppColors.accentGold,
              decoration: InputDecoration(
                hintText: 'Not (opsiyonel)',
                hintStyle: AppTextStyles.body1.copyWith(color: AppColors.textTertiary),
                filled: true,
                fillColor: const Color(0xFF141210),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isSendingOffer.value
                        ? null
                        : controller.sendOffer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: controller.isSendingOffer.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.black),
                          )
                        : const Text('Teklifi Gönder'),
                  )),
            ),
          ],
        ),
      );
    },
  );
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
