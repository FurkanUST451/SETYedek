import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/freelancer_model.dart';
import 'freelancer_detail_controller.dart';

class FreelancerDetailView extends GetView<FreelancerDetailController> {
  const FreelancerDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final f = controller.freelancer;
    final u = controller.user;
    final name = u?.name ?? 'Freelancer';

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBody: true,
      bottomNavigationBar: _BottomBar(onInvite: controller.sendOffer),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _HeroSection(
                  name: name,
                  role: f?.category ?? '',
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (f != null) _StatsRow(freelancer: f),
                      const SizedBox(height: AppSpacing.xl),
                      if (f != null) ...[
                        // Biography
                        Text(
                          'Biography',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          f.bio,
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.65,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        // Portfolio
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Portfolio',
                                style: AppTextStyles.heading3
                                    .copyWith(color: AppColors.textPrimary)),
                            Text(
                              'View All',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.accentGold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _PortfolioRow(freelancer: f),
                      ],
                      const SizedBox(height: 110),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Overlay nav buttons on hero
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _OverlayButton(
                      icon: Icons.arrow_back, onTap: () => Get.back()),
                  _OverlayButton(icon: Icons.more_horiz, onTap: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hero ───────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.name, required this.role});
  final String name;
  final String role;

  @override
  Widget build(BuildContext context) {
    final initials = name
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0] : '')
        .take(2)
        .join();

    return SizedBox(
      height: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Dark cinematic gradient background (photo placeholder)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1C1C1E),
                  Color(0xFF2C2416),
                  Color(0xFF0B0F14),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
          // Large translucent initials as "photo" stand-in
          Center(
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 120,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.06),
                height: 1,
              ),
            ),
          ),
          // Bottom fade to backgroundDark
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.35, 1.0],
                  colors: [
                    Colors.transparent,
                    AppColors.backgroundDark,
                  ],
                ),
              ),
            ),
          ),
          // Name + role overlay at bottom
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.heading1.copyWith(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white.withValues(alpha: 0.65),
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

// ─── Stats Row ───────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.freelancer});
  final FreelancerModel freelancer;

  String get _priceRange {
    final exp = freelancer.experience;
    if (exp <= 2) return '\$1K–\$3K';
    if (exp <= 4) return '\$2K–\$5K';
    if (exp <= 6) return '\$3K–\$8K';
    if (exp <= 8) return '\$5K–\$15K';
    return '\$8K–\$20K';
  }

  int get _trustPercent =>
      ((freelancer.rating / 5.0) * 100).round();

  int get _reviewCount => freelancer.experience * 18;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Trust badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.6)),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            'TRUST $_trustPercent%',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.accentGold,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        // Star rating + review count
        const Icon(Icons.star_rounded, size: 16, color: AppColors.accentGold),
        const SizedBox(width: 4),
        Text(
          '${freelancer.rating.toStringAsFixed(1)} ($_reviewCount)',
          style: AppTextStyles.body2.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(width: AppSpacing.md),
        // Divider
        Container(width: 1, height: 14, color: AppColors.border),
        const SizedBox(width: AppSpacing.md),
        // Price
        Text(
          _priceRange,
          style: AppTextStyles.body2.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

// ─── Portfolio Row ────────────────────────────────────────────────────────────

class _PortfolioRow extends StatelessWidget {
  const _PortfolioRow({required this.freelancer});
  final FreelancerModel freelancer;

  List<List<Color>> get _thumbColors {
    final seed = freelancer.userId.codeUnits.fold(0, (a, b) => a + b);
    final palettes = [
      [const Color(0xFF0D1B2A), const Color(0xFF1B3A5C)],
      [const Color(0xFF1A1000), const Color(0xFF3D2A00)],
      [const Color(0xFF1A0D2E), const Color(0xFF3D1F6E)],
      [const Color(0xFF081820), const Color(0xFF0D3040)],
      [const Color(0xFF1B3A2D), const Color(0xFF2D6A4E)],
      [const Color(0xFF2D1B4E), const Color(0xFF5C3A8A)],
    ];
    return [
      palettes[seed % palettes.length],
      palettes[(seed + 2) % palettes.length],
      palettes[(seed + 4) % palettes.length],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = _thumbColors;
    return Row(
      children: List.generate(3, (i) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors[i],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─── Bottom Bar ──────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onInvite});
  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Bookmark
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surfaceDarkElevated,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.bookmark_border_rounded,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Invite button
          Expanded(
            child: GestureDetector(
              onTap: onInvite,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.accentGold,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Invite to Project',
                  style: AppTextStyles.button.copyWith(
                    color: Colors.black,
                    fontSize: 16,
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

// ─── Overlay Button ──────────────────────────────────────────────────────────

class _OverlayButton extends StatelessWidget {
  const _OverlayButton({required this.icon, required this.onTap});
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
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
