import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';

// ---------------------------------------------------------------------------
// Data model — kept for project_detail_view.dart
// ---------------------------------------------------------------------------

enum ProjectStatus { inProgress, inReview, inRevision, completed }

class ProjectData {
  const ProjectData({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.progress,
    required this.workers,
    required this.budget,
    required this.daysLeft,
    required this.gradientColors,
    required this.stage,
    required this.overview,
    required this.deadline,
    required this.startDate,
    required this.deliverables,
  });

  final String title;
  final String subtitle;
  final ProjectStatus status;
  final double progress;
  final int workers;
  final String budget;
  final int daysLeft;
  final List<Color> gradientColors;
  final int stage;
  final String overview;
  final String deadline;
  final String startDate;
  final String deliverables;
}

const allProjects = [
  ProjectData(
    title: 'Cafe Tanıtım Filmi',
    subtitle: 'SET Halletsin · Ekip kuruluyor',
    status: ProjectStatus.inProgress,
    progress: 0.42,
    workers: 3,
    budget: r'₺42.000',
    daysLeft: 7,
    gradientColors: [Color(0xFF2A1A08), Color(0xFF1A0D04)],
    stage: 0,
    overview:
        'Butik kafe için ürün ve atmosfer odaklı tanıtım filmi. SET ekibi çekim ve kurgu sürecini yönetiyor.',
    deadline: 'Haz 14',
    startDate: 'May 28',
    deliverables: '3 versiyon',
  ),
  ProjectData(
    title: 'Aria Editoryal Kampanya',
    subtitle: 'Moda editoryal · Kış \'26 lookbook',
    status: ProjectStatus.inProgress,
    progress: 0.65,
    workers: 5,
    budget: r'$8.400',
    daysLeft: 12,
    gradientColors: [Color(0xFF3B2510), Color(0xFF1A0D04)],
    stage: 1,
    overview:
        'İpek ve kaşmir parçaların düşük anahtar tungsten aydınlatmasıyla çekildiği altı görünümlük kış editoryal.',
    deadline: 'Ara 14',
    startDate: 'Kas 22',
    deliverables: '12 varlık',
  ),
  ProjectData(
    title: 'Velour Marka Kimliği',
    subtitle: 'Logo sistemi · Restoran markası',
    status: ProjectStatus.inReview,
    progress: 0.80,
    workers: 3,
    budget: r'$4.200',
    daysLeft: 6,
    gradientColors: [Color(0xFF1C1C1C), Color(0xFF0D0D0D)],
    stage: 1,
    overview:
        'Butik restoran için tam marka kimliği paketi. Logo, tipografi, renk paleti ve sosyal medya şablonları dahil.',
    deadline: 'Ara 20',
    startDate: 'Kas 10',
    deliverables: '8 dosya',
  ),
  ProjectData(
    title: 'Noctis Ses Spotu',
    subtitle: 'Ses tasarımı · 30s ticari',
    status: ProjectStatus.inRevision,
    progress: 0.40,
    workers: 4,
    budget: r'$6.750',
    daysLeft: 18,
    gradientColors: [Color(0xFF1A1208), Color(0xFF0E0A04)],
    stage: 2,
    overview:
        'Lüks otomobil markası için 30 saniyelik sinematik ses tasarımı.',
    deadline: 'Oca 5',
    startDate: 'Kas 18',
    deliverables: '3 versiyon',
  ),
];

// ---------------------------------------------------------------------------
// Tab widget
// ---------------------------------------------------------------------------

class ClientProjectsTab extends StatefulWidget {
  const ClientProjectsTab({super.key});

  @override
  State<ClientProjectsTab> createState() => _ClientProjectsTabState();
}

class _ClientProjectsTabState extends State<ClientProjectsTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _tab.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EBD8),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Projeler',
                    style: AppTextStyles.displayXL.copyWith(
                      color: Colors.black87,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SET işleri, teklifler ve biten üretimler.',
                    style: AppTextStyles.body2.copyWith(color: Colors.black45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Custom tab bar ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _TabBtn(label: 'Devam Eden', selected: _tab.index == 0, onTap: () => _tab.animateTo(0)),
                  const SizedBox(width: 8),
                  _TabBtn(label: 'Teklifler', selected: _tab.index == 1, onTap: () => _tab.animateTo(1)),
                  const SizedBox(width: 8),
                  _TabBtn(label: 'Tamamlanan', selected: _tab.index == 2, onTap: () => _tab.animateTo(2)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Tab content ──────────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: const [
                  _DevamEdenTab(),
                  _TekliflerTab(),
                  _TamamlananTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  const _TabBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? Colors.black87 : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.transparent : Colors.black12,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(
            color: selected ? Colors.white : Colors.black54,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Devam Eden tab
// ---------------------------------------------------------------------------

class _DevamEdenTab extends StatelessWidget {
  const _DevamEdenTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: [
        // Active project card
        _ActiveProjectCard(project: allProjects[0]),
        const SizedBox(height: 20),
        // Timeline
        ...const [
          _TimelineItem(
            status: _TimelineStatus.done,
            title: 'Brief onayı',
            date: 'Bugün',
            project: 'Cafe Tanıtım Filmi',
          ),
          _TimelineItem(
            status: _TimelineStatus.current,
            title: 'Ekip kesinleşir',
            date: '18:00',
            project: 'Cafe Tanıtım Filmi',
          ),
          _TimelineItem(
            status: _TimelineStatus.pending,
            title: 'Çekim planlama',
            date: '29 Mayıs',
            project: 'Cafe Tanıtım Filmi',
          ),
          _TimelineItem(
            status: _TimelineStatus.pending,
            title: 'Kurgu teslim',
            date: '4 Haziran',
            project: 'Cafe Tanıtım Filmi',
          ),
        ],
      ],
    );
  }
}

class _ActiveProjectCard extends StatelessWidget {
  const _ActiveProjectCard({required this.project});
  final ProjectData project;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.projectDetail, arguments: {'index': 0}),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: project.gradientColors,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: AppTextStyles.heading2.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    project.subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Teslim',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white38,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${project.daysLeft} Gün',
                  style: AppTextStyles.heading3.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '%${(project.progress * 100).toInt()}',
                  style: AppTextStyles.heading3.copyWith(
                    color: const Color(0xFFE8B84B),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _TimelineStatus { done, current, pending }

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.status,
    required this.title,
    required this.date,
    required this.project,
  });

  final _TimelineStatus status;
  final String title;
  final String date;
  final String project;

  @override
  Widget build(BuildContext context) {
    final bool isDone = status == _TimelineStatus.done;
    final bool isCurrent = status == _TimelineStatus.current;

    Widget indicator;
    if (isDone) {
      indicator = Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26, width: 1.5),
        ),
        child: const Icon(Icons.check_rounded, size: 14, color: Colors.black54),
      );
    } else if (isCurrent) {
      indicator = Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFE8B84B),
        ),
        child: const Icon(Icons.circle, size: 8, color: Colors.white),
      );
    } else {
      indicator = Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12, width: 1.5),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            indicator,
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.body2.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' · $date',
                        style: AppTextStyles.body2.copyWith(color: Colors.black45),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    project,
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFFB8860B),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Teklifler tab
// ---------------------------------------------------------------------------

const _offers = [
  ('A', 'Alperen İ.', 'Teklifi gördü · Director'),
  ('M', 'Mert Kaya', 'Teklifi gördü · Director of Photography'),
  ('E', 'Ece K.', 'Beklemede'),
  ('D', 'Deniz S.', 'Teklifi gördü · Colorist'),
  ('B', 'Baran T.', 'Beklemede'),
];

class _TekliflerTab extends StatelessWidget {
  const _TekliflerTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: [
        // Summary banner
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '5 davetinden 3\'ü görüntülendi',
                style: AppTextStyles.heading2.copyWith(
                  color: Colors.black87,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Mert Kaya ve Ece K. işi inceledi. Buradan mesajlaşabilir veya işi projeye çevirebilirsin.',
                style: AppTextStyles.body2.copyWith(
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Mesajlara git  →',
                    style: AppTextStyles.button.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Gelen Cevaplar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gelen Cevaplar',
              style: AppTextStyles.heading3.copyWith(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            Text(
              'Tümünü Gör  →',
              style: AppTextStyles.caption.copyWith(
                color: const Color(0xFFB8860B),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ..._offers.map((o) => _OfferItem(
              initials: o.$1,
              name: o.$2,
              subtitle: o.$3,
            )),
      ],
    );
  }
}

class _OfferItem extends StatelessWidget {
  const _OfferItem({
    required this.initials,
    required this.name,
    required this.subtitle,
  });

  final String initials;
  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE8D5C0),
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: AppTextStyles.heading3.copyWith(
                  color: const Color(0xFF8D6E63),
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.black45,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(
                AppRoutes.chatDetail,
                arguments: {'name': name},
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0E8DC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Mesaj  →',
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
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tamamlanan tab
// ---------------------------------------------------------------------------

class _TamamlananTab extends StatelessWidget {
  const _TamamlananTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              size: 32,
              color: Colors.black26,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tamamlanan proje yok',
            style: AppTextStyles.heading3.copyWith(color: Colors.black45),
          ),
          const SizedBox(height: 6),
          Text(
            'Biten projeler burada görünür.',
            style: AppTextStyles.body2.copyWith(color: Colors.black26),
          ),
        ],
      ),
    );
  }
}
