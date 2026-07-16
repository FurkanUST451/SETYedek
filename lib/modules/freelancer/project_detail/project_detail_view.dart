import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/project_model.dart';
import 'project_detail_controller.dart';

class FreelancerProjectDetailView
    extends GetView<FreelancerProjectDetailController> {
  const FreelancerProjectDetailView({super.key});

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

  String get _projectCode {
    final p = controller.project;
    return '#PRJ-${p.createdAt.year}-${p.id.substring(0, p.id.length >= 8 ? 8 : p.id.length).toUpperCase()}';
  }

  String get _statusLabel {
    switch (controller.project.status) {
      case ProjectStatus.active:
        return 'AKTİF';
      case ProjectStatus.completed:
        return 'TAMAMLANDI';
      case ProjectStatus.cancelled:
        return 'İPTAL EDİLDİ';
      case ProjectStatus.pending:
        return 'BEKLİYOR';
    }
  }

  Color get _statusColor {
    switch (controller.project.status) {
      case ProjectStatus.active:
        return const Color(0xFF2A7AE8);
      case ProjectStatus.completed:
        return const Color(0xFF2E7D32);
      case ProjectStatus.cancelled:
        return const Color(0xFFD32F2F);
      case ProjectStatus.pending:
        return const Color(0xFFE8882A);
    }
  }

  String get _category => controller.project.category ?? '';

  IconData get _categoryIcon {
    final cat = _category.toLowerCase();
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
    final cat = _category.toLowerCase();
    if (cat.contains('video') || cat.contains('film')) return const Color(0xFFFFF3E0);
    if (cat.contains('fotoğraf') || cat.contains('photo')) return const Color(0xFFE8F5E9);
    if (cat.contains('ses') || cat.contains('müzik')) return const Color(0xFFE3F2FD);
    if (cat.contains('illüstrasyon') || cat.contains('çizim')) return const Color(0xFFF3E5F5);
    return const Color(0xFFF0E8DC);
  }

  Color get _categoryIconColor {
    final cat = _category.toLowerCase();
    if (cat.contains('video') || cat.contains('film')) return const Color(0xFFE8882A);
    if (cat.contains('fotoğraf') || cat.contains('photo')) return const Color(0xFF388E3C);
    if (cat.contains('ses') || cat.contains('müzik')) return const Color(0xFF1976D2);
    if (cat.contains('illüstrasyon') || cat.contains('çizim')) return const Color(0xFF7B1FA2);
    return Colors.black54;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final project = controller.project;

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
                  const SizedBox(width: 48),
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

                    // Proje Bilgileri (brief'ten gelen alanlar)
                    if (project.shootingType != null ||
                        (project.vibes?.isNotEmpty ?? false) ||
                        project.dateRange != null ||
                        project.deliveryTime != null ||
                        project.budget > 0 ||
                        project.location != null) ...[
                      _Section(
                        icon: Icons.assignment_outlined,
                        label: 'PROJE BİLGİLERİ',
                        child: _buildInfoGrid(project),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // İş Tarifi
                    if ((project.notes ?? project.description).isNotEmpty) ...[
                      _Section(
                        icon: Icons.description_outlined,
                        label: 'İŞ TARİFİ',
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            project.notes ?? project.description,
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

                    // İşi Veren (client)
                    Obx(() => _buildClientSection()),
                    const SizedBox(height: 12),

                    // Meta bilgiler
                    _Section(
                      icon: Icons.info_outline,
                      label: 'PROJE KAYDI',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          children: [
                            _InfoRow(
                              label: 'Oluşturulma Tarihi',
                              value: _fmtFull(project.createdAt),
                            ),
                            if (project.deadline != null) ...[
                              const SizedBox(height: 10),
                              _InfoRow(
                                label: 'Teslim Tarihi',
                                value: _fmtFull(project.deadline!),
                              ),
                            ],
                            const SizedBox(height: 10),
                            _InfoRow(
                              label: 'Proje ID',
                              value: _projectCode,
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
    final project = controller.project;
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
                  project.title.isNotEmpty ? project.title : _category,
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (_category.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    _category,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.black45,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Info grid ────────────────────────────────────────────────────────────

  Widget _buildInfoGrid(ProjectModel project) {
    final items = <_GridItem>[];

    if (project.shootingType != null && project.shootingType!.isNotEmpty) {
      items.add(_GridItem(
        icon: Icons.movie_creation_outlined,
        label: 'Çekim Türü',
        value: project.shootingType!,
      ));
    }
    if (project.vibes != null && project.vibes!.isNotEmpty) {
      items.add(_GridItem(
        icon: Icons.show_chart_rounded,
        label: 'Duygu',
        value: project.vibes!.join(', '),
      ));
    }
    if (project.dateRange != null && project.dateRange!.isNotEmpty) {
      items.add(_GridItem(
        icon: Icons.calendar_today_outlined,
        label: 'Çekim Tarihi',
        value: project.dateRange!,
      ));
    }
    if (project.deliveryTime != null && project.deliveryTime!.isNotEmpty) {
      items.add(_GridItem(
        icon: Icons.access_time_outlined,
        label: 'Teslim Süresi',
        value: project.deliveryTime!,
      ));
    }
    if (project.budget > 0) {
      items.add(_GridItem(
        icon: Icons.attach_money_outlined,
        label: 'Bütçe',
        value: '${project.budget.toStringAsFixed(0)} ₺',
      ));
    }
    if (project.location != null && project.location!.isNotEmpty) {
      items.add(_GridItem(
        icon: Icons.location_on_outlined,
        label: 'Lokasyon',
        value: project.location!,
      ));
    }

    if (items.isEmpty) return const SizedBox.shrink();

    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 3) {
      final rowItems = items.sublist(i, i + 3 > items.length ? items.length : i + 3);
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

  // ── Client section ──────────────────────────────────────────────────────

  Widget _buildClientSection() {
    final loading = controller.loadingClient.value;
    final client = controller.client.value;

    return _Section(
      icon: Icons.person_outline,
      label: 'İŞİ VEREN',
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
            : Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE8D5B7),
                      image: client?.avatarUrl != null
                          ? DecorationImage(
                              image: NetworkImage(client!.avatarUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: client?.avatarUrl == null
                        ? Center(
                            child: Text(
                              (client?.fullName.isNotEmpty ?? false)
                                  ? client!.fullName[0].toUpperCase()
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
                  Expanded(
                    child: Text(
                      client?.fullName ?? 'Müşteri',
                      style: const TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.openChat,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A7AE8).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Mesaj',
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2A7AE8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
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
      child: Obx(() => GestureDetector(
            onTap: controller.isOpeningChat.value ? null : controller.openChat,
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
                  if (controller.isOpeningChat.value)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black87,
                      ),
                    )
                  else ...[
                    const Icon(Icons.chat_bubble_outline_rounded,
                        size: 17, color: Colors.black87),
                    const SizedBox(width: 6),
                    Text(
                      'Müşteriyle Mesajlaş',
                      style: AppTextStyles.button.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          )),
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
