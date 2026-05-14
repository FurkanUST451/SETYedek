import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../widgets/set_hero_card.dart';
import '../../../../widgets/set_section_header.dart';

class ProjectDiscoverTab extends StatelessWidget {
  const ProjectDiscoverTab({super.key});

  @override
  Widget build(BuildContext context) {
    final reels = const [
      ('FILM', 'Volkan Otomotiv', 'Marka Filmi', Icons.directions_car_outlined),
      ('AD', 'Yıldız Kahve', 'TV Reklamı', Icons.local_cafe_outlined),
      ('DOC', 'Aydın Hospital', 'Tanıtım Filmi', Icons.health_and_safety_outlined),
      ('MV', 'Ayza', 'Müzik Videosu', Icons.music_note_outlined),
    ];

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
            eyebrow: 'PORTFOLIO',
            title: 'SET\'in işleri',
            description: 'Önceki prodüksiyonlarımızdan örnekler.',
            large: true,
          ),
          const SizedBox(height: AppSpacing.xl),
          ...reels.asMap().entries.map((e) {
            final r = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: SetHeroCard(
                eyebrow: r.$1,
                title: r.$2,
                subtitle: r.$3,
                decorativeIcon: r.$4,
                tag: 'REEL',
                aspectRatio: 16 / 10,
                featured: e.key == 0,
              ),
            );
          }),
        ],
      ),
    );
  }
}
