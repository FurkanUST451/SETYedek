import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/set_avatar.dart';
import '../../../widgets/set_button.dart';
import '../../../widgets/set_card.dart';
import '../../../widgets/set_chip.dart';
import '../../../widgets/set_section_header.dart';
import 'freelancer_detail_controller.dart';

class FreelancerDetailView extends GetView<FreelancerDetailController> {
  const FreelancerDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final f = controller.freelancer;
    final u = controller.user;
    final name = u?.name ?? 'Freelancer';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Stack(
        children: [
          // Hero glow
          Positioned(
            top: -120,
            left: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.14),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              children: [
                // Hero avatar block
                Center(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 40,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: SetAvatar(name: name, size: 112),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (f != null)
                        Text(
                          f.category.toUpperCase(),
                          style: AppTextStyles.eyebrow.copyWith(
                            color: AppColors.accentCyan,
                          ),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(name, style: AppTextStyles.displayXL),
                      if (f != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: secondaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              f.location,
                              style: AppTextStyles.body2.copyWith(
                                color: secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                // Stats row
                if (f != null)
                  Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          icon: Icons.star_rounded,
                          value: f.rating.toStringAsFixed(1),
                          label: 'Puan',
                          color: AppColors.accentCyan,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _StatTile(
                          icon: Icons.work_outline,
                          value: '${f.experience}y',
                          label: 'Deneyim',
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _StatTile(
                          icon: Icons.payments_outlined,
                          value: '₺15K',
                          label: 'Min günlük',
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: AppSpacing.xl),
                // About section
                if (f != null) ...[
                  SetSectionHeader(eyebrow: 'ABOUT', title: 'Hakkında'),
                  const SizedBox(height: AppSpacing.md),
                  SetCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      f.bio,
                      style: AppTextStyles.body1.copyWith(height: 1.6),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // Reels grid
                  SetSectionHeader(eyebrow: 'REELS', title: 'Vitrindeki işler'),
                  const SizedBox(height: AppSpacing.md),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 9 / 14,
                    ),
                    itemCount: 4,
                    itemBuilder: (_, i) => _ReelTile(index: i),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SetSectionHeader(eyebrow: 'SKILLS', title: 'Uzmanlıklar'),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: const [
                      SetChip(label: 'Reklam Filmi'),
                      SetChip(label: 'Müzik Videosu'),
                      SetChip(label: 'Color Grading'),
                      SetChip(label: 'Steadicam'),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.xxl),
                SetButton(
                  text: 'Teklif Gönder',
                  icon: Icons.send_outlined,
                  onPressed: controller.sendOffer,
                  size: SetButtonSize.hero,
                ),
                const SizedBox(height: AppSpacing.md),
                SetButton(
                  text: 'Mesaj Gönder',
                  variant: SetButtonVariant.outline,
                  icon: Icons.chat_bubble_outline,
                  onPressed: controller.openChat,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return SetCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTextStyles.heading2.copyWith(fontSize: 22),
          ),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.eyebrow.copyWith(color: secondaryColor),
          ),
        ],
      ),
    );
  }
}

class _ReelTile extends StatelessWidget {
  const _ReelTile({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.videocam_outlined,
      Icons.movie_outlined,
      Icons.local_movies_outlined,
      Icons.music_note_outlined,
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B232C), Color(0xFF0B0F14)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -10,
              right: -10,
              child: Icon(
                icons[index % icons.length],
                size: 120,
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
            ),
            Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
