import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_text_styles.dart';
import 'freelancer_offer_detail_controller.dart';

class FreelancerOfferDetailView
    extends GetView<FreelancerOfferDetailController> {
  const FreelancerOfferDetailView({super.key});

  // ── Category helpers (same logic as BriefDetailView) ─────────────────────

  static IconData _categoryIcon(String cat) {
    final c = cat.toLowerCase();
    if (c.contains('video') || c.contains('film')) return Icons.videocam_outlined;
    if (c.contains('fotoğraf') || c.contains('photo')) return Icons.camera_alt_outlined;
    if (c.contains('ses') || c.contains('müzik') || c.contains('audio')) {
      return Icons.music_note_outlined;
    }
    if (c.contains('illüstrasyon') || c.contains('çizim')) return Icons.brush_outlined;
    return Icons.work_outline;
  }

  static Color _categoryIconBg(String cat) {
    final c = cat.toLowerCase();
    if (c.contains('video') || c.contains('film')) return const Color(0xFFFFF3E0);
    if (c.contains('fotoğraf') || c.contains('photo')) return const Color(0xFFE8F5E9);
    if (c.contains('ses') || c.contains('müzik')) return const Color(0xFFE3F2FD);
    if (c.contains('illüstrasyon') || c.contains('çizim')) return const Color(0xFFF3E5F5);
    return const Color(0xFFF0E8DC);
  }

  static Color _categoryIconColor(String cat) {
    final c = cat.toLowerCase();
    if (c.contains('video') || c.contains('film')) return const Color(0xFFE8882A);
    if (c.contains('fotoğraf') || c.contains('photo')) return const Color(0xFF388E3C);
    if (c.contains('ses') || c.contains('müzik')) return const Color(0xFF1976D2);
    if (c.contains('illüstrasyon') || c.contains('çizim')) return const Color(0xFF7B1FA2);
    return Colors.black54;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final brief = controller.brief;
    final a = brief.answers;

    return Scaffold(
      backgroundColor: const Color(0xFFF5EBD8),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Top bar ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Text(
                      'İş Teklifi',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading3.copyWith(
                        color: Colors.black87,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // ── Scrollable body ────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header card
                    _buildHeaderCard(brief.category, brief.title),
                    const SizedBox(height: 12),

                    // Brief Bilgileri
                    if (a.shootingType != null ||
                        a.vibes != null ||
                        a.dateRange != null ||
                        a.deliveryTime != null ||
                        a.budget != null ||
                        a.location != null) ...[
                      _Section(
                        icon: Icons.assignment_outlined,
                        label: 'BRIEF BİLGİLERİ',
                        child: _buildBriefGrid(a),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // İş Tarifi
                    if (a.notes != null && a.notes!.isNotEmpty) ...[
                      _Section(
                        icon: Icons.description_outlined,
                        label: 'İŞ TARİFİ',
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            a.notes!,
                            style: AppTextStyles.body2.copyWith(
                              color: Colors.black87,
                              height: 1.6,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Proje Bilgileri
                    _Section(
                      icon: Icons.info_outline,
                      label: 'PROJE BİLGİLERİ',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          children: [
                            _InfoRow(
                              label: 'Gönderilme Tarihi',
                              value: _fmtDate(brief.updatedAt),
                            ),
                            const SizedBox(height: 10),
                            _InfoRow(
                              label: 'Proje ID',
                              value:
                                  '#PRJ-${brief.createdAt.year}-${brief.id.substring(0, 8).toUpperCase()}',
                              mono: true,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Bottom bar ──────────────────────────────────────────────────────────
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ── Header card ────────────────────────────────────────────────────────────

  Widget _buildHeaderCard(String category, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _categoryIconBg(category),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _categoryIcon(category),
              size: 28,
              color: _categoryIconColor(category),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8B84B).withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'YENİ TEKLİF',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB8860B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title.isNotEmpty ? title : category,
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  category,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.black45,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Brief info grid ────────────────────────────────────────────────────────

  Widget _buildBriefGrid(dynamic a) {
    final items = <_GridItem>[];

    if (a.shootingType != null && (a.shootingType as String).isNotEmpty) {
      items.add(_GridItem(
        icon: Icons.movie_creation_outlined,
        label: 'Çekim Türü',
        value: a.shootingType as String,
      ));
    }
    if (a.vibes != null && (a.vibes as List).isNotEmpty) {
      items.add(_GridItem(
        icon: Icons.show_chart_rounded,
        label: 'Duygu',
        value: (a.vibes as List<String>).join(', '),
      ));
    }
    if (a.dateRange != null && (a.dateRange as String).isNotEmpty) {
      items.add(_GridItem(
        icon: Icons.calendar_today_outlined,
        label: 'Çekim Tarihi',
        value: a.dateRange as String,
      ));
    }
    if (a.deliveryTime != null && (a.deliveryTime as String).isNotEmpty) {
      items.add(_GridItem(
        icon: Icons.access_time_outlined,
        label: 'Teslim Süresi',
        value: a.deliveryTime as String,
      ));
    }
    if (a.budget != null && (a.budget as String).isNotEmpty) {
      items.add(_GridItem(
        icon: Icons.attach_money_outlined,
        label: 'Bütçe',
        value: a.budget as String,
      ));
    }
    if (a.location != null && (a.location as String).isNotEmpty) {
      items.add(_GridItem(
        icon: Icons.location_on_outlined,
        label: 'Lokasyon',
        value: a.location as String,
      ));
    }

    if (items.isEmpty) return const SizedBox.shrink();

    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 3) {
      final rowItems =
          items.sublist(i, i + 3 > items.length ? items.length : i + 3);
      while (rowItems.length < 3) {
        rowItems.add(_GridItem(icon: Icons.abc, label: '', value: ''));
      }
      rows.add(Row(
        children: rowItems.asMap().entries.map((e) {
          return Expanded(
            child: e.value.label.isEmpty
                ? const SizedBox.shrink()
                : _GridCell(item: e.value),
          );
        }).toList(),
      ));
      if (i + 3 < items.length) rows.add(const SizedBox(height: 10));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(children: rows),
    );
  }

  // ── Bottom bar ──────────────────────────────────────────────────────────────

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBD8),
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          // Reddet
          Expanded(
            flex: 2,
            child: Obx(() => GestureDetector(
                  onTap: controller.isRejecting.value
                      ? null
                      : controller.rejectOffer,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFD32F2F).withValues(alpha: 0.4),
                      ),
                    ),
                    child: controller.isRejecting.value
                        ? const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFD32F2F),
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.close_rounded,
                                  size: 18, color: Color(0xFFD32F2F)),
                              const SizedBox(width: 6),
                              Text(
                                'Reddet',
                                style: AppTextStyles.button.copyWith(
                                  color: const Color(0xFFD32F2F),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                )),
          ),
          const SizedBox(width: 10),
          // Mesajlaş
          Expanded(
            flex: 3,
            child: Obx(() => GestureDetector(
                  onTap: controller.isOpeningChat.value
                      ? null
                      : controller.openChat,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8B84B),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: controller.isOpeningChat.value
                        ? const Center(
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.chat_bubble_outline_rounded,
                                  size: 17, color: Colors.black87),
                              const SizedBox(width: 6),
                              Text(
                                'Mesajlaş',
                                style: AppTextStyles.button.copyWith(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static const _months = [
    '', 'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
    'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
  ];

  String _fmtDate(DateTime d) {
    return '${d.day} ${_months[d.month]} ${d.year}';
  }
}

// ── Section wrapper ────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.label,
    required this.child,
  });

  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.black45),
              const SizedBox(width: 7),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.black45,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}

// ── Grid item ──────────────────────────────────────────────────────────────────

class _GridItem {
  const _GridItem({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;
}

class _GridCell extends StatelessWidget {
  const _GridCell({required this.item});
  final _GridItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(item.icon, size: 14, color: Colors.black38),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                item.label,
                style: const TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 10,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          item.value,
          style: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ── Info row ───────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.mono = false});
  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 13,
            color: Colors.black45,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: mono ? 'monospace' : 'SpaceGrotesk',
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
