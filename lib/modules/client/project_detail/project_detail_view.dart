import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../home/tabs/client_projects_tab.dart';

const _stageLabels = ['Hazırlık', 'İnceleme', 'Revizyon', 'Tamamlandı'];

const _teamMembers = [
  ('A', 'Aaron', 'Lead Creator', Color(0xFF6EA8FF)),
  ('M', 'Mira', 'Photographer', Color(0xFFD4A843)),
  ('J', 'Jules', 'Stylist', Color(0xFF6FE7DD)),
  ('R', 'Remi', 'Retoucher', Color(0xFFE0A536)),
  ('S', 'Sam', 'Editor', Color(0xFF9B8AFF)),
];

class ProjectDetailView extends StatelessWidget {
  const ProjectDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final index = (args?['index'] as int?) ?? 0;
    final project = allProjects[index.clamp(0, allProjects.length - 1)];

    return Scaffold(
      backgroundColor: const Color(0xFF0E0C0A),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Hero image area
                SliverToBoxAdapter(
                  child: _HeroSection(project: project),
                ),
                // Content
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status badge
                        _StatusBadge(status: project.status),
                        const SizedBox(height: 12),
                        // Title
                        Text(
                          project.title,
                          style: AppTextStyles.displayXL.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          project.subtitle,
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Stage
                        _SectionTitle('Proje Aşaması'),
                        const SizedBox(height: 16),
                        _StageStepper(currentStage: project.stage),
                        const SizedBox(height: 28),
                        // Team
                        _SectionTitle('Ekip'),
                        const SizedBox(height: 4),
                        Text(
                          '${project.workers} kişi',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _TeamRow(count: project.workers),
                        const SizedBox(height: 28),
                        // Overview
                        _SectionTitle('Genel Bakış'),
                        const SizedBox(height: 12),
                        _OverviewCard(text: project.overview),
                        const SizedBox(height: 16),
                        // Detail grid
                        _DetailGrid(project: project),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom action bar
          _BottomBar(project: project),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero Section
// ---------------------------------------------------------------------------

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.project});

  final ProjectData project;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background as hero
        Container(
          height: 260,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                project.gradientColors[0].withValues(alpha: 1.0),
                project.gradientColors[1],
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.image_outlined,
              size: 64,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ),
        // Top nav bar
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      size: 18, color: Colors.white),
                  onPressed: Get.back,
                ),
                const Expanded(
                  child: Text(
                    'Proje',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz,
                      size: 22, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        // Bottom fade
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 80,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xFF0E0C0A).withValues(alpha: 0.9),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Section title
// ---------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.heading2.copyWith(
        fontSize: 18,
        color: Colors.white,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stage Stepper
// ---------------------------------------------------------------------------

class _StageStepper extends StatelessWidget {
  const _StageStepper({required this.currentStage});

  final int currentStage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_stageLabels.length * 2 - 1, (i) {
        if (i.isOdd) {
          // connector line
          final stageIndex = i ~/ 2;
          final passed = stageIndex < currentStage;
          return Expanded(
            child: Container(
              height: 2,
              color: passed
                  ? const Color(0xFFD4A843)
                  : Colors.white.withValues(alpha: 0.15),
            ),
          );
        }
        final stageIndex = i ~/ 2;
        final isActive = stageIndex == currentStage;
        final isPassed = stageIndex < currentStage;

        return Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? const Color(0xFFD4A843)
                    : isPassed
                        ? const Color(0xFFD4A843).withValues(alpha: 0.6)
                        : Colors.white.withValues(alpha: 0.15),
                border: isActive
                    ? Border.all(
                        color: const Color(0xFFD4A843).withValues(alpha: 0.4),
                        width: 3,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _stageLabels[stageIndex],
              style: TextStyle(
                color: isActive
                    ? const Color(0xFFD4A843)
                    : Colors.white.withValues(alpha: 0.4),
                fontSize: 10,
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Team Row
// ---------------------------------------------------------------------------

class _TeamRow extends StatelessWidget {
  const _TeamRow({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final shown = _teamMembers.take(count.clamp(0, _teamMembers.length)).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: shown
            .map(
              (m) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _TeamMember(member: m),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TeamMember extends StatelessWidget {
  const _TeamMember({required this.member});

  final (String, String, String, Color) member;

  @override
  Widget build(BuildContext context) {
    final (initial, name, role, color) = member;
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.2),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
          ),
          child: Center(
            child: Text(
              initial,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          role,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Status Badge (same as list)
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Overview Card
// ---------------------------------------------------------------------------

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1714),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
          width: 0.5,
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.body2.copyWith(
          color: Colors.white.withValues(alpha: 0.75),
          height: 1.6,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Detail Grid (Budget / Deadline / Started / Deliverables)
// ---------------------------------------------------------------------------

class _DetailGrid extends StatelessWidget {
  const _DetailGrid({required this.project});

  final ProjectData project;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.account_balance_wallet_outlined, 'Bütçe', project.budget),
      (Icons.calendar_month_outlined, 'Son Tarih', project.deadline),
      (Icons.play_circle_outline_rounded, 'Başlangıç', project.startDate),
      (Icons.layers_outlined, 'Teslimatlar', project.deliverables),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: items
          .map((item) => _DetailCard(icon: item.$1, label: item.$2, value: item.$3))
          .toList(),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1714),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.heading2.copyWith(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom Action Bar
// ---------------------------------------------------------------------------

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.project});

  final ProjectData project;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Sohbet Aç',
                outlined: true,
                onTap: () => Get.toNamed(
                  '/client/chat-detail',
                  arguments: {'name': project.title},
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.folder_outlined,
                label: 'Dosyalar',
                outlined: false,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.outlined,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool outlined;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: outlined ? Colors.transparent : const Color(0xFFD4A843),
          border: outlined
              ? Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: outlined ? Colors.white : const Color(0xFF1A1200),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.button.copyWith(
                color: outlined ? Colors.white : const Color(0xFF1A1200),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
