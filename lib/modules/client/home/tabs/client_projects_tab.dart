import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/brief_model.dart';
import '../../../../data/models/project_model.dart';
import '../../../../routes/app_routes.dart';
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Projelerim',
                      style: AppTextStyles.displayXL.copyWith(
                        color: Colors.black87,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _IconBtn(icon: Icons.search, onTap: () {}),
                  const SizedBox(width: 4),
                  _IconBtn(icon: Icons.notifications_none_outlined, onTap: () {}),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _FilterChips(),
            const SizedBox(height: 16),
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
                if (controller.briefs.isEmpty && controller.projects.isEmpty) {
                  return const _EmptyState();
                }
                final activeProjects = controller.projects
                    .where((p) => p.status == ProjectStatus.active)
                    .toList();
                return RefreshIndicator(
                  color: const Color(0xFFE8B84B),
                  onRefresh: controller.loadBriefs,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    children: [
                      if (activeProjects.isNotEmpty) ...[
                        Text(
                          'AKTİF PROJELER',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.black45,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...activeProjects.map((p) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _ProjectCard(project: p),
                            )),
                        const SizedBox(height: 8),
                      ],
                      if (controller.briefs.isNotEmpty) ...[
                        if (activeProjects.isNotEmpty) ...[
                          Text(
                            'BRIEFLER',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.black45,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        ...controller.briefs.map((b) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _BriefCard(brief: b, controller: controller),
                            )),
                      ],
                    ],
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
        return 'TEKLİF AŞAMASINDA';
      case 'submitted':
        return 'ANLAŞMA BEKLİYOR';
      default:
        return 'TASLAK';
    }
  }

  Color get _statusColor {
    switch (brief.status) {
      case 'offer_sent':
        return const Color(0xFFE8882A);
      case 'submitted':
        return const Color(0xFF2A7AE8);
      default:
        return Colors.black38;
    }
  }

  String get _offerCountLabel {
    if (brief.sentToIds.isEmpty) return '';
    switch (brief.status) {
      case 'offer_sent':
        return '${brief.sentToIds.length} teklif gönderildi';
      case 'submitted':
        return '${brief.sentToIds.length} teklif alındı';
      default:
        return '';
    }
  }

  String get _displayTitle =>
      brief.title.isNotEmpty ? brief.title : brief.category;

  String get _displaySubtitle {
    final shootingType = brief.answers.shootingType;
    if (shootingType != null && shootingType.isNotEmpty) {
      return shootingType;
    }
    return brief.category;
  }

  IconData get _categoryIcon {
    final cat = brief.category.toLowerCase();
    if (cat.contains('video') || cat.contains('film')) {
      return Icons.videocam_outlined;
    } else if (cat.contains('fotoğraf') || cat.contains('photo')) {
      return Icons.camera_alt_outlined;
    } else if (cat.contains('ses') || cat.contains('müzik') || cat.contains('audio')) {
      return Icons.music_note_outlined;
    } else if (cat.contains('illüstrasyon') || cat.contains('çizim')) {
      return Icons.brush_outlined;
    } else if (cat.contains('yazı') || cat.contains('metin') || cat.contains('içerik')) {
      return Icons.edit_note_outlined;
    }
    return Icons.work_outline;
  }

  Color get _categoryIconBg {
    final cat = brief.category.toLowerCase();
    if (cat.contains('video') || cat.contains('film')) {
      return const Color(0xFFFFF3E0);
    } else if (cat.contains('fotoğraf') || cat.contains('photo')) {
      return const Color(0xFFE8F5E9);
    } else if (cat.contains('ses') || cat.contains('müzik') || cat.contains('audio')) {
      return const Color(0xFFE3F2FD);
    } else if (cat.contains('illüstrasyon') || cat.contains('çizim')) {
      return const Color(0xFFF3E5F5);
    }
    return const Color(0xFFF0E8DC);
  }

  Color get _categoryIconColor {
    final cat = brief.category.toLowerCase();
    if (cat.contains('video') || cat.contains('film')) {
      return const Color(0xFFE8882A);
    } else if (cat.contains('fotoğraf') || cat.contains('photo')) {
      return const Color(0xFF388E3C);
    } else if (cat.contains('ses') || cat.contains('müzik') || cat.contains('audio')) {
      return const Color(0xFF1976D2);
    } else if (cat.contains('illüstrasyon') || cat.contains('çizim')) {
      return const Color(0xFF7B1FA2);
    }
    return Colors.black54;
  }

  static const _months = [
    '', 'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
    'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
  ];

  String _formatDate(DateTime date) {
    return '${date.day} ${_months[date.month]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final offerLabel = _offerCountLabel;

    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Status row ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 0),
              child: Row(
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
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _openEditFlow(context),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0E8DC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 17,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Title + icon row ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _categoryIconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_categoryIcon, size: 24, color: _categoryIconColor),
                  ),
                  const SizedBox(width: 12),
                  // Title + subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _displayTitle,
                          style: AppTextStyles.heading3.copyWith(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _displaySubtitle,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Offer count
                  if (offerLabel.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 2),
                      child: Text(
                        offerLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.black38,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                ],
              ),
            ),

            // ── Stats row (delivery / budget / date) ─────────────────────
            if (brief.answers.deliveryTime != null ||
                brief.answers.budget != null ||
                brief.answers.dateRange != null) ...[
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (brief.answers.deliveryTime != null)
                      Expanded(
                        child: _StatCell(
                          icon: Icons.access_time_outlined,
                          label: 'Teslim Süresi',
                          value: brief.answers.deliveryTime!,
                        ),
                      ),
                    if (brief.answers.budget != null)
                      Expanded(
                        child: _StatCell(
                          icon: Icons.attach_money_outlined,
                          label: 'Bütçe',
                          value: brief.answers.budget!,
                        ),
                      ),
                    if (brief.answers.dateRange != null)
                      Expanded(
                        child: _StatCell(
                          icon: Icons.calendar_today_outlined,
                          label: 'Çekim Tarihi',
                          value: brief.answers.dateRange!,
                        ),
                      ),
                  ],
                ),
              ),
            ],

            // ── Location ──────────────────────────────────────────────────
            if (brief.answers.location != null &&
                brief.answers.location!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 15, color: Colors.black38),
                    const SizedBox(width: 4),
                    Text(
                      brief.answers.location!,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ── Brief notes preview ───────────────────────────────────────
            if (brief.answers.notes != null &&
                brief.answers.notes!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  brief.answers.notes!,
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.black54,
                    fontSize: 13,
                    height: 1.45,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],

            // ── Footer ────────────────────────────────────────────────────
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 10, 14, 12),
              child: Row(
                children: [
                  Text(
                    'Son güncelleme: ${_formatDate(brief.updatedAt)}',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.black38,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right,
                      size: 18, color: Colors.black26),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    Get.toNamed(
      AppRoutes.briefDetail,
      arguments: {'brief': brief},
    );
  }

  void _openEditFlow(BuildContext context) {
    Get.toNamed(
      AppRoutes.sendOffer,
      arguments: {
        'category': brief.category,
        'brief': brief,
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Active project card
// ---------------------------------------------------------------------------

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.work_history_outlined,
                size: 22, color: Color(0xFF2E7D32)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title.isNotEmpty ? project.title : 'Proje',
                  style: AppTextStyles.heading3.copyWith(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${project.budget.toStringAsFixed(0)} ₺ · Aktif',
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF2E7D32),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 18, color: Colors.black26),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stat cell helper
// ---------------------------------------------------------------------------

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: Colors.black38),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.black38,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}


// ---------------------------------------------------------------------------
// Icon button helper
// ---------------------------------------------------------------------------

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.black54),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter chips
// ---------------------------------------------------------------------------

class _FilterChips extends StatefulWidget {
  @override
  State<_FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<_FilterChips> {
  int _selected = 0;

  static const _labels = [
    'Tümü',
    'Teklif Aşamasında',
    'Anlaşma Bekliyor',
    'Aktif',
    'Tamamlandı',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = i == _selected;
          return GestureDetector(
            onTap: () => setState(() => _selected = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: active ? Colors.black87 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: active
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Text(
                _labels[i],
                style: AppTextStyles.caption.copyWith(
                  color: active ? Colors.white : Colors.black54,
                  fontWeight:
                      active ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
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
