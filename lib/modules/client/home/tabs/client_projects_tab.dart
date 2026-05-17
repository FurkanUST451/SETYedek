import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';

// ---------------------------------------------------------------------------
// Shared model & data
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
  final int stage; // 0=Preparing,1=In Review,2=Revision,3=Completed
  final String overview;
  final String deadline;
  final String startDate;
  final String deliverables;
}

const allProjects = [
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
        'İpek ve kaşmir parçaların düşük anahtar tungsten aydınlatmasıyla çekildiği altı görünümlük kış editoryal. Teslimat 12 rötuşlanmış hero görsel ve 4 motion clip içerir.',
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
        'Lüks otomobil markası için 30 saniyelik sinematik ses tasarımı. Orkestrasyonlu arka plan müziği ve efektler dahil.',
    deadline: 'Oca 5',
    startDate: 'Kas 18',
    deliverables: '3 versiyon',
  ),
  ProjectData(
    title: 'Noctis Ses Spotu II',
    subtitle: 'Ses tasarımı · 30s ticari',
    status: ProjectStatus.inRevision,
    progress: 0.40,
    workers: 4,
    budget: r'$6.750',
    daysLeft: 18,
    gradientColors: [Color(0xFF121820), Color(0xFF080C10)],
    stage: 2,
    overview:
        'Teknoloji ürünü lansmanı için 30 saniyelik ses tasarımı. Modern elektronik arka plan ve voiceover miksajı.',
    deadline: 'Oca 8',
    startDate: 'Kas 25',
    deliverables: '3 versiyon',
  ),
];

// ---------------------------------------------------------------------------
// Tab
// ---------------------------------------------------------------------------

class ClientProjectsTab extends StatelessWidget {
  const ClientProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            sliver: SliverToBoxAdapter(child: _Header()),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _ProjectCard(
                    project: allProjects[i],
                    index: i,
                  ),
                ),
                childCount: allProjects.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Projects',
                style: AppTextStyles.displayXL.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${allProjects.length} aktif proje',
                style: AppTextStyles.body2
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border, width: 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Geçmiş',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 10, color: AppColors.textSecondary),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Project Card (full width)
// ---------------------------------------------------------------------------

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.index});

  final ProjectData project;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.projectDetail,
        arguments: {'index': index},
      ),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: project.gradientColors,
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.07),
            width: 0.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: badge + avatars
              Row(
                children: [
                  _StatusBadge(status: project.status),
                  const Spacer(),
                  _AvatarStack(count: project.workers),
                ],
              ),
              const Spacer(),
              // Title + subtitle
              Text(
                project.title,
                style: AppTextStyles.heading2.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                project.subtitle,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              // Stats
              Row(
                children: [
                  _Stat(
                      icon: Icons.people_outline_rounded,
                      label: '${project.workers}'),
                  const SizedBox(width: 14),
                  _Stat(
                      icon: Icons.attach_money_rounded,
                      label: project.budget),
                  const SizedBox(width: 14),
                  _Stat(
                      icon: Icons.calendar_today_outlined,
                      label: '${project.daysLeft} gün'),
                  const Spacer(),
                  Text(
                    '${(project.progress * 100).toInt()}%',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: project.progress,
                  minHeight: 3,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFD4A843),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable sub-widgets
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ProjectStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      ProjectStatus.inProgress => (
          'IN PROGRESS',
          const Color(0xFFD4A843).withValues(alpha: 0.18),
          const Color(0xFFD4A843),
        ),
      ProjectStatus.inReview => (
          'IN REVIEW',
          const Color(0xFF6EA8FF).withValues(alpha: 0.18),
          const Color(0xFF6EA8FF),
        ),
      ProjectStatus.inRevision => (
          'IN REVISION',
          const Color(0xFFE0A536).withValues(alpha: 0.18),
          const Color(0xFFE0A536),
        ),
      ProjectStatus.completed => (
          'COMPLETED',
          const Color(0xFF34C77B).withValues(alpha: 0.18),
          const Color(0xFF34C77B),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final shown = count.clamp(0, 3);
    final extra = count - shown;
    final colors = [
      const Color(0xFF6EA8FF),
      const Color(0xFFD4A843),
      const Color(0xFF6FE7DD),
    ];

    return SizedBox(
      width: shown * 16.0 + (extra > 0 ? 22 : 0),
      height: 24,
      child: Stack(
        children: [
          for (int i = 0; i < shown; i++)
            Positioned(
              left: i * 14.0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors[i % colors.length].withValues(alpha: 0.8),
                  border: Border.all(color: const Color(0xFF141210), width: 1.5),
                ),
              ),
            ),
          if (extra > 0)
            Positioned(
              left: shown * 14.0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.12),
                  border: Border.all(color: const Color(0xFF141210), width: 1.5),
                ),
                child: Center(
                  child: Text(
                    '+$extra',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.white.withValues(alpha: 0.45)),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
