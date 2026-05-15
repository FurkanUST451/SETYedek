import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/dummy/dummy_data.dart';
import '../../../../data/models/work_model.dart';

class ClientDiscoverTab extends StatefulWidget {
  const ClientDiscoverTab({super.key});

  @override
  State<ClientDiscoverTab> createState() => _ClientDiscoverTabState();
}

class _ClientDiscoverTabState extends State<ClientDiscoverTab> {
  // null = "Tüm İşler" filter active
  WorkType? _filter;

  List<WorkModel> get _works {
    if (_filter == null) return DummyData.works;
    return DummyData.works.where((w) => w.type == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Header()),
          SliverToBoxAdapter(
            child: _FilterBar(
              selected: _filter,
              onSelect: (t) => setState(() => _filter = t),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              120,
            ),
            sliver: SliverList.separated(
              itemCount: _works.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.lg),
              itemBuilder: (_, i) => _WorkCard(work: _works[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// HEADER — "Keşfet" + search icon
// ─────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Keşfet',
              style: AppTextStyles.displayXL.copyWith(
                fontSize: 36,
                color: textColor,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search_rounded,
              color: textColor,
              size: 26,
            ),
            splashRadius: 24,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// FILTER BAR — horizontal pill chips, gold accent on selected
// ─────────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onSelect});

  final WorkType? selected;
  final ValueChanged<WorkType?> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: [
          _FilterChip(
            label: 'Tüm İşler',
            selected: selected == null,
            onTap: () => onSelect(null),
          ),
          const SizedBox(width: AppSpacing.sm),
          ...WorkType.values.map((t) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: _FilterChip(
                  label: t.label,
                  selected: selected == t,
                  onTap: () => onSelect(t),
                ),
              )),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(AppRadius.full);

    final bg = selected
        ? AppColors.accentGold
        : Colors.transparent;
    final fg = selected
        ? const Color(0xFF1A1410)
        : (isDark ? AppColors.textPrimary : AppColors.textPrimaryLight);
    final borderColor = selected
        ? AppColors.accentGold
        : (isDark ? AppColors.border : AppColors.borderLight)
            .withValues(alpha: 0.7);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: radius,
            border: Border.all(color: borderColor, width: 0.8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// WORK CARD — cover placeholder + title + studio + actions
// ─────────────────────────────────────────────────────────────────

class _WorkCard extends StatelessWidget {
  const _WorkCard({required this.work});

  final WorkModel work;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CoverPlaceholder(coverImage: work.coverImage, type: work.type),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    work.title,
                    style: AppTextStyles.heading3.copyWith(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'by ',
                          style: AppTextStyles.caption.copyWith(
                            color: secondaryColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        TextSpan(
                          text: work.studio,
                          style: AppTextStyles.eyebrow.copyWith(
                            color: secondaryColor,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            _MetricRow(
              likes: work.likes,
              comments: work.comments,
              secondaryColor: secondaryColor,
            ),
          ],
        ),
      ],
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder({required this.coverImage, required this.type});

  final String? coverImage;
  final WorkType type;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg);

    return ClipRRect(
      borderRadius: radius,
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background — image if provided, otherwise dark gradient
            if (coverImage != null)
              Image.asset(coverImage!, fit: BoxFit.cover)
            else
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B232C), Color(0xFF0B0F14)],
                  ),
                ),
              ),
            // Subtle decorative type icon in corner (visible when no image)
            if (coverImage == null)
              Positioned(
                right: -16,
                bottom: -16,
                child: Icon(
                  _iconFor(type),
                  size: 120,
                  color: AppColors.primary.withValues(alpha: 0.12),
                ),
              ),
            // Play button overlay — videos & motion content
            if (type == WorkType.video ||
                type == WorkType.vfx ||
                type == WorkType.cgi)
              const Center(child: _PlayButton()),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(WorkType t) {
    switch (t) {
      case WorkType.video:
        return Icons.movie_outlined;
      case WorkType.photo:
        return Icons.camera_alt_outlined;
      case WorkType.cgi:
        return Icons.threed_rotation_outlined;
      case WorkType.vfx:
        return Icons.auto_awesome_outlined;
      case WorkType.ai:
        return Icons.psychology_outlined;
    }
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.2),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.7),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 18,
            spreadRadius: -2,
          ),
        ],
      ),
      child: const Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.likes,
    required this.comments,
    required this.secondaryColor,
  });

  final int likes;
  final int comments;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _IconCount(
          icon: Icons.favorite_border_rounded,
          count: likes,
          color: secondaryColor,
        ),
        const SizedBox(width: AppSpacing.md),
        _IconCount(
          icon: Icons.mode_comment_outlined,
          count: comments,
          color: secondaryColor,
        ),
        const SizedBox(width: AppSpacing.md),
        Icon(
          Icons.bookmark_border_rounded,
          color: secondaryColor,
          size: 18,
        ),
      ],
    );
  }
}

class _IconCount extends StatelessWidget {
  const _IconCount({
    required this.icon,
    required this.count,
    required this.color,
  });

  final IconData icon;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 5),
        Text(
          _format(count),
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  String _format(int n) {
    if (n >= 1000) {
      final k = n / 1000;
      return k % 1 == 0 ? '${k.toInt()}K' : '${k.toStringAsFixed(1)}K';
    }
    return n.toString();
  }
}
