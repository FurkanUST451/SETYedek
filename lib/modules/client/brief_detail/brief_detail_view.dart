import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/freelancer_model.dart';
import 'brief_detail_controller.dart';

class BriefDetailView extends GetView<BriefDetailController> {
  const BriefDetailView({super.key});

  // ── Helpers ───────────────────────────────────────────────────────────────

  static const _months = [
    '', 'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
    'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
  ];

  String _fmtFull(DateTime d) {
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${_months[d.month]} ${d.year} - $h:$m';
  }

  String get _projectId {
    final b = controller.brief;
    return '#PRJ-${b.createdAt.year}-${b.id.substring(0, 8).toUpperCase()}';
  }

  String get _statusLabel {
    switch (controller.brief.status) {
      case 'offer_sent':
        return 'TEKLİF AŞAMASINDA';
      case 'submitted':
        return 'ANLAŞMA BEKLİYOR';
      default:
        return 'TASLAK';
    }
  }

  Color get _statusColor {
    switch (controller.brief.status) {
      case 'offer_sent':
        return const Color(0xFFE8882A);
      case 'submitted':
        return const Color(0xFF2A7AE8);
      default:
        return Colors.black38;
    }
  }

  IconData get _categoryIcon {
    final cat = controller.brief.category.toLowerCase();
    if (cat.contains('video') || cat.contains('film')) {
      return Icons.videocam_outlined;
    } else if (cat.contains('fotoğraf') || cat.contains('photo')) {
      return Icons.camera_alt_outlined;
    } else if (cat.contains('ses') || cat.contains('müzik') || cat.contains('audio')) {
      return Icons.music_note_outlined;
    } else if (cat.contains('illüstrasyon') || cat.contains('çizim')) {
      return Icons.brush_outlined;
    }
    return Icons.work_outline;
  }

  Color get _categoryIconBg {
    final cat = controller.brief.category.toLowerCase();
    if (cat.contains('video') || cat.contains('film')) return const Color(0xFFFFF3E0);
    if (cat.contains('fotoğraf') || cat.contains('photo')) return const Color(0xFFE8F5E9);
    if (cat.contains('ses') || cat.contains('müzik')) return const Color(0xFFE3F2FD);
    if (cat.contains('illüstrasyon') || cat.contains('çizim')) return const Color(0xFFF3E5F5);
    return const Color(0xFFF0E8DC);
  }

  Color get _categoryIconColor {
    final cat = controller.brief.category.toLowerCase();
    if (cat.contains('video') || cat.contains('film')) return const Color(0xFFE8882A);
    if (cat.contains('fotoğraf') || cat.contains('photo')) return const Color(0xFF388E3C);
    if (cat.contains('ses') || cat.contains('müzik')) return const Color(0xFF1976D2);
    if (cat.contains('illüstrasyon') || cat.contains('çizim')) return const Color(0xFF7B1FA2);
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
            // ── Top bar ──────────────────────────────────────────────────
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
                      'Proje Detayı',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading3.copyWith(
                        color: Colors.black87,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz, color: Colors.black54),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // ── Scrollable body ──────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header card
                    _buildHeaderCard(),
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

                    // İş Tarifi (notes)
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

                    // Freelancerlar
                    Obx(() => _buildFreelancerSection()),
                    const SizedBox(height: 12),

                    // Proje Bilgileri
                    _Section(
                      icon: Icons.info_outline,
                      label: 'PROJE BİLGİLERİ',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          children: [
                            _InfoRow(
                              label: 'Oluşturulma Tarihi',
                              value: _fmtFull(brief.createdAt),
                            ),
                            const SizedBox(height: 10),
                            _InfoRow(
                              label: 'Son Güncelleme',
                              value: _fmtFull(brief.updatedAt),
                            ),
                            const SizedBox(height: 10),
                            _InfoRow(
                              label: 'Proje ID',
                              value: _projectId,
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

      // ── Bottom action bar ────────────────────────────────────────────────
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ── Header card ────────────────────────────────────────────────────────────

  Widget _buildHeaderCard() {
    final brief = controller.brief;
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
          // Category icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _categoryIconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_categoryIcon, size: 28, color: _categoryIconColor),
          ),
          const SizedBox(width: 14),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _statusLabel,
                  style: AppTextStyles.caption.copyWith(
                    color: _statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  brief.title.isNotEmpty ? brief.title : brief.category,
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  brief.category,
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

    // Split into rows of 3
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 3) {
      final rowItems = items.sublist(i, i + 3 > items.length ? items.length : i + 3);
      // Pad to 3 with empty if needed
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

  // ── Freelancer section ──────────────────────────────────────────────────────

  Widget _buildFreelancerSection() {
    final brief = controller.brief;
    if (brief.sentToIds.isEmpty) return const SizedBox.shrink();

    final freelancers = controller.freelancers;
    final loading = controller.loadingFreelancers.value;
    final count = brief.sentToIds.length;
    final show = freelancers.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Section(
          icon: Icons.send_outlined,
          label: 'TEKLİF GÖNDERİLEN FREELANCERLAR ($count)',
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: loading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFFE8B84B),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      ...show.map((f) => _FreelancerRow(freelancer: f)),
                      if (show.length < count) ...[
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: controller.sendToNewFreelancer,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Text(
                                  'Tümünü Gör',
                                  style: AppTextStyles.body2.copyWith(
                                    color: const Color(0xFFE8882A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                  color: Color(0xFFE8882A),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 12),
      ],
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
          // Düzenle
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: controller.openEdit,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.edit_outlined,
                        size: 18, color: Colors.black87),
                    const SizedBox(width: 6),
                    Text(
                      'Düzenle',
                      style: AppTextStyles.button.copyWith(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Yeni Freelancer'a Gönder
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: controller.sendToNewFreelancer,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send_outlined,
                        size: 17, color: Colors.black87),
                    const SizedBox(width: 6),
                    Text(
                      "Yeni Freelancer'a Gönder",
                      style: AppTextStyles.button.copyWith(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

// ── Freelancer row ─────────────────────────────────────────────────────────────

class _FreelancerRow extends StatelessWidget {
  const _FreelancerRow({required this.freelancer});
  final FreelancerModel freelancer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE8D5B7),
              image: freelancer.profileImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(freelancer.profileImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: freelancer.profileImageUrl == null
                ? Center(
                    child: Text(
                      freelancer.name.isNotEmpty
                          ? freelancer.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          // Name + category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  freelancer.fullName,
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (freelancer.categories.isNotEmpty)
                  Text(
                    freelancer.categories.first,
                    style: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
              ],
            ),
          ),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF2A7AE8).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Teklif Bekleniyor',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2A7AE8),
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, size: 18, color: Colors.black26),
        ],
      ),
    );
  }
}
