import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/dummy/dummy_data.dart';
import '../../../../data/models/freelancer_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widgets/set_avatar.dart';
import '../../../../widgets/set_card.dart';
import '../../../../widgets/set_chip.dart';
import '../../../../widgets/set_hero_card.dart';
import '../../../../widgets/set_section_header.dart';

class ClientDiscoverTab extends StatefulWidget {
  const ClientDiscoverTab({super.key});

  @override
  State<ClientDiscoverTab> createState() => _ClientDiscoverTabState();
}

class _ClientDiscoverTabState extends State<ClientDiscoverTab> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final freelancers = DummyData.freelancers;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          120,
        ),
        children: [
          SetSectionHeader(
            eyebrow: 'DISCOVER',
            title: 'Keşfet',
            description: 'Projelerin için doğru freelancer\'ı bul.',
            large: true,
          ),
          const SizedBox(height: AppSpacing.xl),
          // Featured hero card
          SetHeroCard(
            eyebrow: 'FEATURED',
            title: 'Bu hafta öne çıkan setler',
            subtitle: 'En çok talep gören prodüksiyon ekipleri',
            decorativeIcon: Icons.local_movies_outlined,
            tag: 'TRENDING',
            aspectRatio: 16 / 9,
            featured: true,
          ),
          const SizedBox(height: AppSpacing.xl),
          // Categories
          _Categories(
            selectedIndex: _selectedCategory,
            onSelect: (i) => setState(() => _selectedCategory = i),
          ),
          const SizedBox(height: AppSpacing.xl),
          SetSectionHeader(
            eyebrow: 'CREATORS',
            title: 'Önerilen freelancerlar',
          ),
          const SizedBox(height: AppSpacing.lg),
          ...freelancers.map((f) {
            final user = DummyData.users.firstWhere(
              (u) => u.id == f.userId,
              orElse: () => UserModel(
                id: f.userId,
                name: 'Bilinmiyor',
                email: '',
                role: UserRole.freelancer,
                createdAt: DateTime.now(),
              ),
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _FreelancerTile(
                freelancer: f,
                user: user,
                secondaryColor: secondaryColor,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories({required this.selectedIndex, required this.onSelect});

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: DummyData.categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) {
          return SetChip(
            label: DummyData.categories[i],
            selected: i == selectedIndex,
            onTap: () => onSelect(i),
          );
        },
      ),
    );
  }
}

class _FreelancerTile extends StatelessWidget {
  const _FreelancerTile({
    required this.freelancer,
    required this.user,
    required this.secondaryColor,
  });

  final FreelancerModel freelancer;
  final UserModel user;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return SetCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: () => Get.toNamed(
        AppRoutes.freelancerDetail,
        arguments: {'freelancer': freelancer, 'user': user},
      ),
      child: Row(
        children: [
          SetAvatar(name: user.name, size: 56),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: AppTextStyles.heading3),
                const SizedBox(height: 2),
                Text(
                  '${freelancer.category} · ${freelancer.location}',
                  style: AppTextStyles.body2.copyWith(color: secondaryColor),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: AppColors.accentCyan,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      freelancer.rating.toStringAsFixed(1),
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: secondaryColor,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '${freelancer.experience} yıl deneyim',
                      style: AppTextStyles.caption.copyWith(
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: secondaryColor, size: 22),
        ],
      ),
    );
  }
}
