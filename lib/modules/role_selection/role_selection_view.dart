import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/user_model.dart';
import 'role_selection_controller.dart';

class RoleSelectionView extends StatefulWidget {
  const RoleSelectionView({super.key});

  @override
  State<RoleSelectionView> createState() => _RoleSelectionViewState();
}

class _RoleSelectionViewState extends State<RoleSelectionView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _thresholdHit = false;
  bool _navigating = false;

  // divider value: 0.0 = full right (Hizmet Al), 1.0 = full left (Hizmet Ver)
  static const double _threshold = 0.75;
  static const Duration _snapDuration = Duration(milliseconds: 420);
  static const Duration _selectDuration = Duration(milliseconds: 950);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      value: 0.5,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails _) => _thresholdHit = false;

  void _onDragUpdate(DragUpdateDetails details) {
    if (_navigating) return;
    final w = MediaQuery.of(context).size.width;
    final v = (_ctrl.value + details.delta.dx / w).clamp(0.0, 1.0);
    _ctrl.value = v;
    if (!_thresholdHit && (v >= _threshold || v <= 1.0 - _threshold)) {
      _thresholdHit = true;
      HapticFeedback.lightImpact();
    }
  }

  void _onDragEnd(DragEndDetails _) {
    if (_navigating) return;
    final controller = Get.find<RoleSelectionController>();
    if (_ctrl.value >= _threshold) {
      // Left (Hizmet Ver / freelancer) wins
      _navigating = true;
      _ctrl
          .animateTo(1.0, duration: _selectDuration, curve: Curves.easeInOut)
          .then((_) {
        if (mounted) controller.select(UserRole.freelancer);
      });
    } else if (_ctrl.value <= 1.0 - _threshold) {
      // Right (Hizmet Al / client) wins
      _navigating = true;
      _ctrl
          .animateTo(0.0, duration: _selectDuration, curve: Curves.easeInOut)
          .then((_) {
        if (mounted) controller.select(UserRole.client);
      });
    } else {
      _ctrl.animateTo(0.5, duration: _snapDuration, curve: Curves.elasticOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: Stack(
          children: [
            // Right panel — Hizmet Al (client)
            AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) {
                final w = (1.0 - _ctrl.value) * size.width;
                if (w <= 0) return const SizedBox.shrink();
                return Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: w,
                  child: ClipRect(
                    child: OverflowBox(
                      maxWidth: size.width,
                      maxHeight: size.height,
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: size.width,
                        height: size.height,
                        child: _RolePanel(
                          imageAsset: AppAssets.roleProjectClient2,
                          eyebrow: 'HİZMET AL',
                          title: 'Projeni',
                          titleAccent: 'hayata geçir.',
                          description: AppStrings.roleClientDesc,
                          accent: AppColors.primary,
                          crossAxis: CrossAxisAlignment.end,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Left panel — Hizmet Ver (freelancer)
            AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) {
                final w = _ctrl.value * size.width;
                if (w <= 0) return const SizedBox.shrink();
                return Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: w,
                  child: ClipRect(
                    child: OverflowBox(
                      maxWidth: size.width,
                      maxHeight: size.height,
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: size.width,
                        height: size.height,
                        child: _RolePanel(
                          imageAsset: AppAssets.roleFreelancer,
                          eyebrow: 'HİZMET VER',
                          title: 'Yeteneğini',
                          titleAccent: 'paraya çevir.',
                          description: AppStrings.roleFreelancerDesc,
                          accent: AppColors.accentCyan,
                          crossAxis: CrossAxisAlignment.start,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Divider + drag handle
            AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) {
                return Positioned(
                  left: _ctrl.value * size.width - 1.5,
                  top: 0,
                  bottom: 0,
                  width: 3,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        color: Colors.white.withValues(alpha: 0.45),
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.unfold_more,
                          color: Colors.black87,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Top — wordmark + tagline
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
                        AppStrings.appName,
                        style: AppTextStyles.wordmark.copyWith(
                          fontSize: 24,
                          letterSpacing: 4,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppStrings.roleSelectionTitle,
                        style: AppTextStyles.body2.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom hint
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Text(
                    'Kaydırarak seç',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.55),
                      letterSpacing: 1.5,
                    ),
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

class _RolePanel extends StatelessWidget {
  const _RolePanel({
    required this.imageAsset,
    required this.eyebrow,
    required this.title,
    required this.titleAccent,
    required this.description,
    required this.accent,
    required this.crossAxis,
    required this.textAlign,
  });

  final String imageAsset;
  final String eyebrow;
  final String title;
  final String titleAccent;
  final String description;
  final Color accent;
  final CrossAxisAlignment crossAxis;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(imageAsset, fit: BoxFit.cover, alignment: Alignment.center),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.55),
                Colors.black.withValues(alpha: 0.25),
                Colors.black.withValues(alpha: 0.92),
              ],
              stops: const [0.0, 0.35, 1.0],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: crossAxis,
              children: [
                const Spacer(),
                Text(
                  eyebrow,
                  textAlign: textAlign,
                  style: AppTextStyles.eyebrow.copyWith(color: accent),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  title,
                  textAlign: textAlign,
                  style: AppTextStyles.displayXL.copyWith(
                    color: Colors.white,
                    fontSize: 40,
                    height: 1.05,
                  ),
                ),
                Text(
                  titleAccent,
                  textAlign: textAlign,
                  style: AppTextStyles.displayXL.copyWith(
                    color: accent,
                    fontSize: 40,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  description,
                  textAlign: textAlign,
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 96),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
