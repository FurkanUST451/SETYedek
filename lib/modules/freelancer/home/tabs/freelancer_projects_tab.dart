import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/project_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/set_section_header.dart';
import '../freelancer_projects_controller.dart';

class FreelancerProjectsTab extends StatelessWidget {
  const FreelancerProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FreelancerProjectsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor = isDark ? Colors.white54 : Colors.black45;

    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: controller.loadProjects,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                120,
              ),
              children: [
                SetSectionHeader(
                  eyebrow: 'WORKSPACE',
                  title: 'Projelerim',
                  description: 'Aktif ve tamamlanan işler',
                  large: true,
                ),
                const SizedBox(height: AppSpacing.xl),
                if (controller.projects.isEmpty)
                  _EmptyState(secondaryColor: secondaryColor)
                else
                  ...controller.projects.map((project) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Obx(() => _ProjectCard(
                            project: project,
                            clientName:
                                controller.clientNames[project.clientId],
                          )),
                    );
                  }),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Project card — anlaşılan iş kartı (brief + anlaşılan ücret verilerine göre)
// ---------------------------------------------------------------------------

/// Anlaşılan iş sürecinin adımları. Şu an modelde yalnızca genel bir
/// [ProjectStatus] tutulduğu için, adım göstergesi bu duruma göre kabaca
/// eşlenir: proje oluştuğunda "Anlaşıldı" tamamlanmış sayılır, tamamlanan
/// projelerde ise tüm adımlar tamamlanmış gösterilir.
const _projectSteps = ['Anlaşıldı', 'Çekim Planlandı', 'Çekim Tamamlandı', 'Teslim Edildi', 'Tamamlandı'];
const _projectStepIcons = [
  Icons.handshake_outlined,
  Icons.event_available_outlined,
  Icons.videocam_outlined,
  Icons.local_shipping_outlined,
  Icons.flag_outlined,
];

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, this.clientName});

  final ProjectModel project;
  final String? clientName;

  String get _category => project.category ?? '';

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

  Color get _categoryColor {
    final cat = _category.toLowerCase();
    if (cat.contains('video') || cat.contains('film')) {
      return const Color(0xFF4A55C4);
    } else if (cat.contains('fotoğraf') || cat.contains('photo')) {
      return const Color(0xFFE8952A);
    } else if (cat.contains('ses') || cat.contains('müzik') || cat.contains('audio')) {
      return const Color(0xFF1976D2);
    } else if (cat.contains('illüstrasyon') || cat.contains('çizim')) {
      return const Color(0xFF7B1FA2);
    }
    return const Color(0xFF6D6259);
  }

  String get _statusLabel {
    switch (project.status) {
      case ProjectStatus.active:
        return 'Anlaşıldı';
      case ProjectStatus.completed:
        return 'Tamamlandı';
      case ProjectStatus.cancelled:
        return 'İptal Edildi';
      case ProjectStatus.pending:
        return 'Bekliyor';
    }
  }

  Color get _statusColor {
    switch (project.status) {
      case ProjectStatus.active:
      case ProjectStatus.completed:
        return const Color(0xFF2E7D32);
      case ProjectStatus.cancelled:
        return const Color(0xFFD32F2F);
      case ProjectStatus.pending:
        return const Color(0xFFE8882A);
    }
  }

  int get _currentStepIndex {
    switch (project.status) {
      case ProjectStatus.completed:
        return _projectSteps.length - 1;
      case ProjectStatus.pending:
      case ProjectStatus.active:
      case ProjectStatus.cancelled:
        return 0;
    }
  }

  Color get _stepAccent {
    switch (project.status) {
      case ProjectStatus.completed:
        return const Color(0xFF2E7D32);
      case ProjectStatus.cancelled:
        return const Color(0xFFD32F2F);
      case ProjectStatus.pending:
      case ProjectStatus.active:
        return const Color(0xFF4A55C4);
    }
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
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.freelancerProjectDetail,
        arguments: {'project': project},
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Kategori rozeti + başlık + durum + menü ──────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 10, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: _categoryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_categoryIcon, size: 17, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _category.isEmpty
                        ? const SizedBox.shrink()
                        : Text(
                            _category,
                            style: AppTextStyles.caption.copyWith(
                              color: _categoryColor,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
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
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert,
                        size: 19, color: Colors.black38),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                    splashRadius: 16,
                  ),
                ],
              ),
            ),

            // ── Brief notu (hizmet alanın yazdığı) ────────────────────────
            if ((project.notes ?? project.description).isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Text(
                  project.notes ?? project.description,
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.black45,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            const SizedBox(height: 14),
            Divider(height: 1, color: Colors.black.withValues(alpha: 0.07)),

            // ── Bilgi grid: çekim türü / teslim süresi / çekim tarihi ────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCell(
                      icon: Icons.movie_creation_outlined,
                      label: 'Çekim Türü',
                      value: (project.shootingType?.isNotEmpty ?? false)
                          ? project.shootingType!
                          : '—',
                    ),
                  ),
                  Expanded(
                    child: _StatCell(
                      icon: Icons.access_time_outlined,
                      label: 'Teslim Süresi',
                      value: (project.deliveryTime?.isNotEmpty ?? false)
                          ? project.deliveryTime!
                          : '—',
                    ),
                  ),
                  Expanded(
                    child: _StatCell(
                      icon: Icons.calendar_today_outlined,
                      label: 'Çekim Tarihi',
                      value: (project.dateRange?.isNotEmpty ?? false)
                          ? project.dateRange!
                          : '—',
                    ),
                  ),
                ],
              ),
            ),

            // ── Bilgi grid: konum / anlaşılan fiyat / hizmet alan ────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCell(
                      icon: Icons.location_on_outlined,
                      label: 'Konum',
                      value: (project.location?.isNotEmpty ?? false)
                          ? project.location!
                          : '—',
                    ),
                  ),
                  Expanded(
                    child: _StatCell(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Anlaşılan Fiyat',
                      value: '${project.budget.toStringAsFixed(0)} ₺',
                      valueColor: const Color(0xFF2E7D32),
                    ),
                  ),
                  Expanded(
                    child: _StatCell(
                      icon: Icons.people_outline,
                      label: 'Hizmet Alan',
                      value: clientName ?? '—',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            Divider(height: 1, color: Colors.black.withValues(alpha: 0.07)),

            // ── Tarihler + detay butonu ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _DateCell(
                      label: 'Anlaşma Tarihi',
                      value: _formatDate(project.createdAt),
                    ),
                  ),
                  Expanded(
                    child: _DateCell(
                      label: 'Son Teslim Tarihi',
                      value: project.deadline != null
                          ? _formatDate(project.deadline!)
                          : '—',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.12)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Detaylar',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            size: 16, color: Colors.black54),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Süreç adımları ────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black.withValues(alpha: 0.07)),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(10, 14, 10, 16),
              child: _StepProgress(
                currentStep: _currentStepIndex,
                accent: _stepAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Date cell helper
// ---------------------------------------------------------------------------

class _DateCell extends StatelessWidget {
  const _DateCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

// ---------------------------------------------------------------------------
// Step progress — Anlaşıldı / Çekim Planlandı / Çekim Tamamlandı / Teslim
// Edildi / Tamamlandı
// ---------------------------------------------------------------------------

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.currentStep, required this.accent});

  final int currentStep;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    // Her adım eşit genişlikte bir Expanded segmenttir; bağlantı çizgisi de
    // o segmentin İÇİNDE (daire öncesi/sonrası iki yarım çizgi) çizilir.
    // Böylece etiket metni her zaman segment genişliğine sabitlenir ve
    // uzun etiketler (ör. "Çekim Tamamlandı") satırı taşırmadan sarar.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_projectSteps.length, (i) {
        final isDone = i <= currentStep;
        final lineBeforeActive = i > 0 && i <= currentStep;
        final lineAfterActive = i < _projectSteps.length - 1 && i < currentStep;

        return Expanded(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 1.5,
                      color: i == 0
                          ? Colors.transparent
                          : (lineBeforeActive ? accent : Colors.black12),
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone ? accent : Colors.white,
                      border: Border.all(
                        color: isDone ? accent : Colors.black26,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      isDone ? Icons.check : _projectStepIcons[i],
                      size: 11,
                      color: isDone ? Colors.white : Colors.black26,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1.5,
                      color: i == _projectSteps.length - 1
                          ? Colors.transparent
                          : (lineAfterActive ? accent : Colors.black12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _projectSteps[i],
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  color: isDone ? Colors.black87 : Colors.black38,
                  fontSize: 8.5,
                  fontWeight: isDone ? FontWeight.w700 : FontWeight.w500,
                  height: 1.15,
                ),
              ),
            ],
          ),
        );
      }),
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
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.caption.copyWith(
                  color: valueColor ?? Colors.black87,
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
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.secondaryColor});

  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(Icons.folder_open_outlined, size: 40, color: secondaryColor),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Henüz proje yok',
            style: AppTextStyles.heading3.copyWith(color: secondaryColor),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Bir teklif kabul edildiğinde burada görünür.',
            style: AppTextStyles.body2.copyWith(color: secondaryColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
