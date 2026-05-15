import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_strings.dart';
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
  final PageController _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RoleSelectionController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _page = i),
            children: [
              _RolePage(
                imageAsset: AppAssets.roleProjectClient2,
                eyebrow: 'HİZMET AL',
                title: 'Projeni',
                titleAccent: 'hayata geçir.',
                description: AppStrings.roleClientDesc,
                onContinue: () => controller.select(UserRole.client),
                accent: AppColors.primary,
              ),
              _RolePage(
                imageAsset: AppAssets.roleFreelancer,
                eyebrow: 'HİZMET VER',
                title: 'Yeteneğini',
                titleAccent: 'paraya çevir.',
                description: AppStrings.roleFreelancerDesc,
                onContinue: () => controller.select(UserRole.freelancer),
                accent: AppColors.accentCyan,
              ),
            ],
          ),
          // Top: wordmark + tagline
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
          // Bottom: page indicator + swipe hint
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PageDots(activeIndex: _page, count: 2),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Kaydırarak seç',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.55),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RolePage extends StatelessWidget {
  const _RolePage({
    required this.imageAsset,
    required this.eyebrow,
    required this.title,
    required this.titleAccent,
    required this.description,
    required this.onContinue,
    required this.accent,
  });

  final String imageAsset;
  final String eyebrow;
  final String title;
  final String titleAccent;
  final String description;
  final VoidCallback onContinue;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imageAsset,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        // Dark gradient overlay — top fades, bottom solid for legibility
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  eyebrow,
                  style: AppTextStyles.eyebrow.copyWith(color: accent),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  title,
                  style: AppTextStyles.displayXL.copyWith(
                    color: Colors.white,
                    fontSize: 44,
                    height: 1.05,
                  ),
                ),
                Text(
                  titleAccent,
                  style: AppTextStyles.displayXL.copyWith(
                    color: accent,
                    fontSize: 44,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  description,
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                SetButton(
                  text: 'Devam Et',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: onContinue,
                  size: SetButtonSize.hero,
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

class _PageDots extends StatelessWidget {
  const _PageDots({required this.activeIndex, required this.count});

  final int activeIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        );
      }),
    );
  }
}
