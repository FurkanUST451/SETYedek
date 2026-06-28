import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/brief_model.dart';
import '../client_projects_controller.dart';

// ---------------------------------------------------------------------------
// Tab widget
// ---------------------------------------------------------------------------

class ClientProjectsTab extends StatelessWidget {
  const ClientProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientProjectsController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF5EBD8),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Projelerim',
                    style: AppTextStyles.displayXL.copyWith(
                      color: Colors.black87,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gönderdiğin briefler ve teklifler.',
                    style: AppTextStyles.body2.copyWith(color: Colors.black45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFE8B84B),
                    ),
                  );
                }
                if (controller.errorMsg.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Projeler yüklenemedi',
                            style: AppTextStyles.heading3
                                .copyWith(color: Colors.black45),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: controller.loadBriefs,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Tekrar Dene',
                                style: AppTextStyles.button
                                    .copyWith(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (controller.briefs.isEmpty) {
                  return const _EmptyState();
                }
                return RefreshIndicator(
                  color: const Color(0xFFE8B84B),
                  onRefresh: controller.loadBriefs,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    itemCount: controller.briefs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _BriefCard(
                      brief: controller.briefs[i],
                      controller: controller,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Brief card
// ---------------------------------------------------------------------------

class _BriefCard extends StatelessWidget {
  const _BriefCard({required this.brief, required this.controller});

  final BriefModel brief;
  final ClientProjectsController controller;

  String get _statusLabel {
    switch (brief.status) {
      case 'offer_sent':
        return 'Teklif Gönderildi';
      case 'submitted':
        return 'Brief Gönderildi';
      default:
        return 'Taslak';
    }
  }

  Color get _statusColor {
    switch (brief.status) {
      case 'offer_sent':
        return const Color(0xFFE8B84B);
      case 'submitted':
        return const Color(0xFF6EA8FF);
      default:
        return Colors.black38;
    }
  }

  String get _displayTitle =>
      brief.title.isNotEmpty ? brief.title : brief.category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _displayTitle,
                        style: AppTextStyles.heading3.copyWith(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        brief.category,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.black45,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _showEdit(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0E8DC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Düzenle',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _statusLabel,
                style: AppTextStyles.caption.copyWith(
                  color: _statusColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            if (brief.sentToIds.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '${brief.sentToIds.length} freelancer\'a teklif gönderildi',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.black45,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _BriefDetailSheet(brief: brief),
    );
  }

  void _showEdit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _BriefEditSheet(brief: brief, controller: controller),
    );
  }
}

// ---------------------------------------------------------------------------
// Brief detail bottom sheet
// ---------------------------------------------------------------------------

class _BriefDetailSheet extends StatelessWidget {
  const _BriefDetailSheet({required this.brief});

  final BriefModel brief;

  String get _displayTitle =>
      brief.title.isNotEmpty ? brief.title : brief.category;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 32 + bottomInset),
      decoration: const BoxDecoration(
        color: Color(0xFFF5EBD8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _displayTitle,
            style: AppTextStyles.heading2.copyWith(
              color: Colors.black87,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            brief.category,
            style: AppTextStyles.caption.copyWith(color: Colors.black45),
          ),
          const SizedBox(height: 20),
          if (brief.answers.notes != null &&
              brief.answers.notes!.isNotEmpty) ...[
            Text(
              'BRIEF',
              style: AppTextStyles.caption.copyWith(
                color: Colors.black45,
                letterSpacing: 1.2,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                brief.answers.notes!,
                style: AppTextStyles.body2.copyWith(
                  color: Colors.black87,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (brief.answers.budget != null) ...[
            Row(
              children: [
                const Icon(Icons.monetization_on_outlined,
                    size: 16, color: Colors.black45),
                const SizedBox(width: 6),
                Text(
                  brief.answers.budget!,
                  style: AppTextStyles.body2.copyWith(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          if (brief.sentToIds.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8B84B).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.people_outline,
                      size: 18, color: Color(0xFFB8860B)),
                  const SizedBox(width: 8),
                  Text(
                    '${brief.sentToIds.length} freelancer\'a teklif gönderildi',
                    style: AppTextStyles.body2.copyWith(
                      color: const Color(0xFFB8860B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Brief edit bottom sheet
// ---------------------------------------------------------------------------

class _BriefEditSheet extends StatefulWidget {
  const _BriefEditSheet({required this.brief, required this.controller});

  final BriefModel brief;
  final ClientProjectsController controller;

  @override
  State<_BriefEditSheet> createState() => _BriefEditSheetState();
}

class _BriefEditSheetState extends State<_BriefEditSheet> {
  late final TextEditingController _text;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _text = TextEditingController(text: widget.brief.answers.notes ?? '');
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final trimmed = _text.text.trim();
    if (trimmed.isEmpty) return;
    setState(() => _saving = true);
    await widget.controller.updateBriefNotes(widget.brief.id, trimmed);
    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottomInset),
      decoration: const BoxDecoration(
        color: Color(0xFFF5EBD8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Brief\'i Düzenle',
            style: AppTextStyles.heading2.copyWith(
              color: Colors.black87,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _text,
            maxLines: 7,
            maxLength: 2000,
            style: AppTextStyles.body2.copyWith(color: Colors.black87),
            decoration: InputDecoration(
              hintText: "Brief'ini buraya yaz...",
              hintStyle: AppTextStyles.body2.copyWith(color: Colors.black26),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              counterText: '',
              isDense: true,
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _saving ? null : _save,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFE8B84B),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.black54,
                      ),
                    )
                  : Text(
                      'Kaydet',
                      style: AppTextStyles.button.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.folder_open_outlined,
              size: 34,
              color: Colors.black26,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz proje yok',
            style: AppTextStyles.heading3.copyWith(color: Colors.black45),
          ),
          const SizedBox(height: 6),
          Text(
            'Brief gönderdikten sonra buraya düşer.',
            style: AppTextStyles.body2.copyWith(color: Colors.black26),
          ),
        ],
      ),
    );
  }
}
