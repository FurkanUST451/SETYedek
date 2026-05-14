import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/user_model.dart';
import '../../widgets/set_button.dart';
import 'role_selection_controller.dart';

class RoleSelectionView extends StatefulWidget {
  const RoleSelectionView({super.key});

  @override
  State<RoleSelectionView> createState() => _RoleSelectionViewState();
}

class _RoleSelectionViewState extends State<RoleSelectionView> {
  final PageController _pageController = PageController(initialPage: 1);
  int _page = 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RoleSelectionController>();

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _page = i),
        children: [
          _ProjectClientStripPage(
            pageController: _pageController,
            onContinue: () => controller.select(UserRole.projectClient),
          ),
          _SplitView(
            onLeftTap: () => _pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
            ),
            onRightTap: () => _pageController.animateToPage(
              2,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
            ),
            page: _page,
          ),
          _FreelancerChooserPage(
            onBeFreelancer: () => controller.select(UserRole.freelancer),
            onFindFreelancer: () => controller.select(UserRole.client),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// PAGE 0: PROJECT CLIENT — Photo strip + drag-to-expand
// ─────────────────────────────────────────────────────────────────

class _ProjectClientStripPage extends StatefulWidget {
  const _ProjectClientStripPage({
    required this.pageController,
    required this.onContinue,
  });

  final PageController pageController;
  final VoidCallback onContinue;

  @override
  State<_ProjectClientStripPage> createState() =>
      _ProjectClientStripPageState();
}

class _ProjectClientStripPageState extends State<_ProjectClientStripPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _expandCtrl;
  late final Animation<double> _t;
  bool _dragOwned = false;

  @override
  void initState() {
    super.initState();
    _expandCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _t = CurvedAnimation(parent: _expandCtrl, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    _dragOwned = false;
  }

  void _handleDragUpdate(DragUpdateDetails details, double screenWidth) {
    final dx = details.delta.dx;
    // Photo only expands when dragging right (dx > 0) starting from collapsed.
    // Once we've started expanding (or photo is partially open), all dx steers the animation.
    if (_expandCtrl.value > 0 || dx > 0) {
      _dragOwned = true;
      _expandCtrl.value =
          (_expandCtrl.value + dx / (screenWidth * 0.6)).clamp(0.0, 1.0);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    final v = details.primaryVelocity ?? 0;

    if (_dragOwned) {
      // Snap expand state to nearest end
      if (_expandCtrl.value > 0.5 || v > 250) {
        _expandCtrl.forward();
      } else {
        _expandCtrl.reverse();
      }
    } else if (_expandCtrl.value == 0 && v < -250) {
      // Collapsed and user swiped left → go to split view page
      widget.pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: (d) => _handleDragUpdate(d, screenSize.width),
      onHorizontalDragEnd: _handleDragEnd,
      child: AnimatedBuilder(
        animation: _t,
        builder: (ctx, _) {
          final t = _t.value;
          // Photo strip: 1/3 → 3/3 of screen width
          final photoWidth = screenSize.width * (1 / 3 + (2 / 3) * t);

          return Stack(
            children: [
              // Photo (right-aligned, expanding leftward)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: photoWidth,
                child: ClipRect(
                  child: OverflowBox(
                    minWidth: screenSize.width,
                    maxWidth: screenSize.width,
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      AppAssets.roleProjectClient2,
                      fit: BoxFit.cover,
                      width: screenSize.width,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),

              // Dark scrim on the LEFT portion of the photo when expanded
              // (only kicks in after t > 0.5; helps button readability)
              if (t > 0.3)
                Positioned(
                  right: 0,
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: ((t - 0.3) / 0.7).clamp(0, 1),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black.withValues(alpha: 0.6),
                              Colors.black.withValues(alpha: 0.0),
                            ],
                            stops: const [0.0, 0.6],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Text content panel (left, fades out as photo expands)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: screenSize.width - photoWidth,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: (1 - t * 1.6).clamp(0.0, 1.0),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.xl,
                          AppSpacing.md,
                          AppSpacing.lg,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'PROJENİ',
                              style: AppTextStyles.eyebrow.copyWith(
                                color: AppColors.accentCyan,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'SET',
                              style: AppTextStyles.displayXL.copyWith(
                                color: textColor,
                                fontSize: 48,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              'Yapsın',
                              style: AppTextStyles.displayXL.copyWith(
                                color: AppColors.primary,
                                fontSize: 48,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Prodüksiyon sürecini profesyonel ekiplere bırak. İhtiyacını anlat, gerisini biz halledelim.',
                              style: AppTextStyles.body2.copyWith(
                                color: secondaryColor,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            // Hint chip: swipe right
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14,
                                  color: AppColors.accentCyan,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Kaydır',
                                  style: AppTextStyles.eyebrow.copyWith(
                                    color: AppColors.accentCyan,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Expanded-state content (overlay text + Devam Et button)
              if (t > 0.4)
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: t < 0.85, // only tappable when fully expanded
                    child: Opacity(
                      opacity: ((t - 0.4) / 0.6).clamp(0.0, 1.0),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                            vertical: AppSpacing.lg,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'HAZIRSIN',
                                style: AppTextStyles.eyebrow.copyWith(
                                  color: AppColors.accentCyan,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'SET\'i',
                                style: AppTextStyles.displayXL.copyWith(
                                  color: Colors.white,
                                  fontSize: 56,
                                  height: 1.0,
                                ),
                              ),
                              Text(
                                'kuralım',
                                style: AppTextStyles.displayXL.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 56,
                                  height: 1.0,
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: screenSize.width * 0.6,
                                child: SetButton(
                                  text: 'Devam Et',
                                  icon: Icons.arrow_forward_rounded,
                                  onPressed: widget.onContinue,
                                  size: SetButtonSize.hero,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xxl),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// PAGE 1: SPLIT VIEW (center, initial)
// ─────────────────────────────────────────────────────────────────

class _SplitView extends StatelessWidget {
  const _SplitView({
    required this.onLeftTap,
    required this.onRightTap,
    required this.page,
  });

  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;
  final int page;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: _SplitHalf(
                imageAsset: AppAssets.roleProjectClient,
                eyebrow: 'PROJENİ',
                title: 'SET',
                titleAccent: 'Yapsın',
                description:
                    'Prodüksiyon sürecini profesyonel ekiplere bırak. İhtiyacını anlat, gerisini biz halledelim.',
                onTap: onLeftTap,
              ),
            ),
            Expanded(
              child: _SplitHalf(
                imageAsset: AppAssets.roleFreelancer,
                eyebrow: 'FREELANCER',
                title: 'Bul / Ol',
                titleAccent: '',
                description:
                    'Yetenekli freelancerları keşfet veya yeteneklerini sergile. Doğru işler, doğru kişilerle buluşsun.',
                onTap: onRightTap,
              ),
            ),
          ],
        ),
        // Top wordmark + tagline + progress
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Column(
                children: [
                  Text(
                    'SET',
                    style: AppTextStyles.wordmark.copyWith(
                      fontSize: 32,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Başlamak için rolünü seç',
                    style: AppTextStyles.body2.copyWith(
                      color: secondaryColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _TopProgress(page: page),
                ],
              ),
            ),
          ),
        ),
        // Center swap handle
        const Center(child: _SwapHandle()),
        // Bottom dots + hint
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Kaydırarak seçim yap',
                    style: AppTextStyles.caption.copyWith(
                      color: secondaryColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _BottomDots(activeIndex: page),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SplitHalf extends StatelessWidget {
  const _SplitHalf({
    required this.imageAsset,
    required this.eyebrow,
    required this.title,
    required this.titleAccent,
    required this.description,
    required this.onTap,
  });

  final String imageAsset;
  final String eyebrow;
  final String title;
  final String titleAccent;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return InkWell(
      onTap: onTap,
      child: SizedBox.expand(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: MediaQuery.of(context).size.height * 0.45,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                      Colors.black,
                    ],
                    stops: const [0, 0.2, 0.6],
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                120,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eyebrow,
                    style: AppTextStyles.eyebrow.copyWith(
                      color: AppColors.accentCyan,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    title,
                    style: AppTextStyles.heading1.copyWith(
                      color: textColor,
                      fontSize: 30,
                      height: 1.05,
                    ),
                  ),
                  if (titleAccent.isNotEmpty)
                    Text(
                      titleAccent,
                      style: AppTextStyles.heading1.copyWith(
                        color: AppColors.primary,
                        fontSize: 30,
                        height: 1.05,
                      ),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    description,
                    style: AppTextStyles.body2.copyWith(
                      color: secondaryColor,
                      height: 1.5,
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

class _SwapHandle extends StatelessWidget {
  const _SwapHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDeep],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.5),
            blurRadius: 28,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: const Icon(
        Icons.swap_horiz_rounded,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// PAGE 2: FREELANCER CHOOSER (kept as-is)
// ─────────────────────────────────────────────────────────────────

class _FreelancerChooserPage extends StatelessWidget {
  const _FreelancerChooserPage({
    required this.onBeFreelancer,
    required this.onFindFreelancer,
  });

  final VoidCallback onBeFreelancer;
  final VoidCallback onFindFreelancer;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppAssets.roleFreelancer,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.4),
                Colors.black.withValues(alpha: 0.2),
                Colors.black.withValues(alpha: 0.85),
              ],
              stops: const [0, 0.35, 1.0],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'FREELANCER',
                  style: AppTextStyles.eyebrow.copyWith(
                    color: AppColors.accentCyan,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Hangisi sensin?',
                  style: AppTextStyles.displayXL.copyWith(
                    fontSize: 44,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Yetenekli freelancerları keşfet veya yeteneklerini sergile.',
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const Spacer(),
                _ChoiceCard(
                  icon: Icons.workspace_premium_outlined,
                  title: 'Freelancer Ol',
                  subtitle: 'Yeteneklerini sergile, projeler al',
                  onTap: onBeFreelancer,
                  accentColor: AppColors.primary,
                ),
                const SizedBox(height: AppSpacing.md),
                _ChoiceCard(
                  icon: Icons.search,
                  title: 'Freelancer Bul',
                  subtitle: 'Projen için doğru kişiyi seç',
                  onTap: onFindFreelancer,
                  accentColor: AppColors.accentCyan,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.accentColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.22),
                blurRadius: 24,
                spreadRadius: -4,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accentColor.withValues(alpha: 0.35),
                      accentColor.withValues(alpha: 0.15),
                    ],
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.heading3.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded,
                  color: accentColor, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// TOP PROGRESS (3-segment)
// ─────────────────────────────────────────────────────────────────

class _TopProgress extends StatelessWidget {
  const _TopProgress({required this.page});

  final int page;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactive = isDark ? AppColors.border : AppColors.borderLight;

    return SizedBox(
      width: 180,
      height: 3,
      child: Row(
        children: List.generate(3, (i) {
          final active = i == page;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : inactive,
                borderRadius: BorderRadius.circular(AppRadius.full),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// BOTTOM DOTS
// ─────────────────────────────────────────────────────────────────

class _BottomDots extends StatelessWidget {
  const _BottomDots({required this.activeIndex});

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactive = isDark ? AppColors.border : AppColors.borderLight;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : inactive,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        );
      }),
    );
  }
}
