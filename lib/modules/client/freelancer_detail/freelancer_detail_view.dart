import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
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

    final reviewCount = (f?.experience ?? 3) * 18;
    final jobCount = (f?.experience ?? 3) * 12 + 15;
    final trustScore = ((f?.rating ?? 4.9) * 19.5).round();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(AppAssets.choosePageBg, fit: BoxFit.cover),
            ),
            SafeArea(
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left,
                              color: Colors.black87, size: 28),
                          onPressed: () => Get.back(),
                        ),
                        const Spacer(),
                        Text(
                          'SET',
                          style: AppTextStyles.wordmark.copyWith(
                            color: Colors.black87,
                            fontSize: 20,
                            letterSpacing: 2,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.upload_outlined,
                              color: Colors.black87),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_horiz,
                              color: Colors.black87),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: NestedScrollView(
                      headerSliverBuilder: (_, __) => [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20, 16, 20, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Avatar
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 96,
                                      height: 96,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8D5C0),
                                        borderRadius:
                                            BorderRadius.circular(48),
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        size: 52,
                                        color: Color(0xFF8D6E63),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 4,
                                      right: 4,
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4CAF50),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                // Name
                                Text(
                                  name,
                                  style: AppTextStyles.heading1.copyWith(
                                    color: Colors.black87,
                                    fontSize: 28,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Direktör · ${f?.category ?? ''}',
                                  style: AppTextStyles.body1.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Inline stats
                                Text(
                                  '★ ${f?.rating.toStringAsFixed(1) ?? '4.9'} ($reviewCount)  ·  ${(f?.experience ?? 3) * 8 + 20} yaş',
                                  style: AppTextStyles.body2.copyWith(
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${f?.location ?? 'İstanbul'}, Türkiye  ·  $jobCount İş',
                                  style: AppTextStyles.body2.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${f?.experience ?? 3} Yıl Deneyim',
                                  style: AppTextStyles.body2.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Action buttons
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: controller.openChat,
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.circle_outlined,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Mesaj Gönder',
                                                style: AppTextStyles.button
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: controller.sendOffer,
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white
                                                .withValues(alpha: 0.7),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            border: Border.all(
                                              color: const Color(0xFFE8B84B),
                                              width: 1.5,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Teklif Gönder',
                                            style: AppTextStyles.button
                                                .copyWith(
                                              color: const Color(0xFFB8860B),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        // Tab bar
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _TabHeaderDelegate(
                            TabBar(
                              tabs: const [
                                Tab(text: 'İşler'),
                                Tab(text: 'Hakkında'),
                                Tab(text: 'Yorumlar'),
                              ],
                              labelStyle: AppTextStyles.button
                                  .copyWith(fontSize: 15),
                              unselectedLabelStyle: AppTextStyles.body1
                                  .copyWith(fontSize: 15),
                              labelColor: Colors.black87,
                              unselectedLabelColor: Colors.black38,
                              indicatorColor: Colors.black87,
                              indicatorWeight: 2,
                              dividerColor: Colors.black12,
                            ),
                          ),
                        ),
                      ],
                      body: TabBarView(
                        children: [
                          // İşler tab
                          _IslerTab(
                            freelancer: f,
                            reviewCount: reviewCount,
                            trustScore: trustScore,
                          ),
                          // Hakkında tab
                          _HakkindaTab(
                            bio: f?.bio ?? '',
                            trustScore: trustScore,
                            freelancer: f,
                          ),
                          // Yorumlar tab
                          _YorumlarTab(
                            reviewCount: reviewCount,
                            freelancer: f,
                          ),
                        ],
                      ),
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

// ─── Tab delegate ──────────────────────────────────────────────────────────────

class _TabHeaderDelegate extends SliverPersistentHeaderDelegate {
  _TabHeaderDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFF5EBD8).withValues(alpha: 0.95),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabHeaderDelegate old) => false;
}

// ─── İşler Tab ────────────────────────────────────────────────────────────────

class _IslerTab extends StatelessWidget {
  const _IslerTab({
    required this.freelancer,
    required this.reviewCount,
    required this.trustScore,
  });

  final FreelancerModel? freelancer;
  final int reviewCount;
  final int trustScore;

  List<Map<String, String>> _projects() {
    final seed =
        (freelancer?.userId.codeUnits.fold(0, (a, b) => a + b) ?? 42);
    final names = ['Beko', 'Migros', 'Ajet', 'Türk Telekom', 'Pepsi', 'Nike'];
    final types = [
      'Reklam Filmi',
      'Marka Filmi',
      'Tanıtım',
      'Kurumsal',
      'Viral',
      'Belgesel'
    ];
    return List.generate(4, (i) {
      return {
        'brand': names[(seed + i) % names.length],
        'type': types[(seed + i) % types.length],
      };
    });
  }

  final List<List<Color>> _warmPalettes = const [
    [Color(0xFF5C4033), Color(0xFF8D6E63)],
    [Color(0xFF4A3728), Color(0xFF795548)],
    [Color(0xFF6D4C41), Color(0xFFA1887F)],
    [Color(0xFF3E2723), Color(0xFF6D4C41)],
  ];

  @override
  Widget build(BuildContext context) {
    final projects = _projects();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        // Öne Çıkan İşler
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Öne Çıkan İşler',
              style: AppTextStyles.heading3.copyWith(color: Colors.black87),
            ),
            Text(
              'Tümünü Gör →',
              style: AppTextStyles.caption.copyWith(
                color: const Color(0xFFB8860B),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: projects.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final p = projects[i];
              final colors = _warmPalettes[i % _warmPalettes.length];
              return Container(
                width: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Placeholder icon
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_circle_outline,
                          color: Colors.white54, size: 22),
                    ),
                    const Spacer(),
                    Text(
                      p['brand']!,
                      style: AppTextStyles.heading3.copyWith(
                          color: Colors.white, fontSize: 13),
                    ),
                    Text(
                      p['type']!,
                      style: AppTextStyles.caption.copyWith(
                          color: Colors.white60, fontSize: 11),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward,
                          color: Colors.white, size: 14),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 28),
        // Yorumlar preview
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Yorumlar ($reviewCount)',
              style: AppTextStyles.heading3.copyWith(color: Colors.black87),
            ),
            Text(
              'Tümünü Gör',
              style: AppTextStyles.caption.copyWith(
                color: const Color(0xFFB8860B),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _ReviewItem(
          brand: 'Migros',
          projectType: 'Marka Filmi',
          rating: 5.0,
          comment: 'Harika bir iş çıkardı.',
          initials: 'M',
        ),
        const SizedBox(height: 8),
        _ReviewItem(
          brand: 'Beko',
          projectType: 'Reklam Filmi',
          rating: 4.9,
          comment: 'Çok profesyonel çalışma.',
          initials: 'B',
        ),
      ],
    );
  }
}

// ─── Hakkında Tab ─────────────────────────────────────────────────────────────

class _HakkindaTab extends StatelessWidget {
  const _HakkindaTab({
    required this.bio,
    required this.trustScore,
    required this.freelancer,
  });

  final String bio;
  final int trustScore;
  final FreelancerModel? freelancer;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        // Trust badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE8B84B)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            'TRUST $trustScore%',
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFFB8860B),
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Biyografi',
          style: AppTextStyles.caption.copyWith(color: Colors.black45),
        ),
        const SizedBox(height: 6),
        Text(
          bio.isNotEmpty ? bio : 'Henüz biyografi eklenmemiş.',
          style:
              AppTextStyles.body1.copyWith(color: Colors.black87, height: 1.65),
        ),
        const SizedBox(height: 24),
        Text(
          'Uzmanlık',
          style: AppTextStyles.caption.copyWith(color: Colors.black45),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            freelancer?.category ?? '',
            'Kurgu',
            'Color Grading',
            'Drone',
          ]
              .where((s) => s.isNotEmpty)
              .map((s) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Text(
                      s,
                      style: AppTextStyles.caption
                          .copyWith(color: Colors.black87),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ─── Yorumlar Tab ─────────────────────────────────────────────────────────────

class _YorumlarTab extends StatelessWidget {
  const _YorumlarTab({
    required this.reviewCount,
    required this.freelancer,
  });

  final int reviewCount;
  final FreelancerModel? freelancer;

  @override
  Widget build(BuildContext context) {
    final dummyReviews = [
      ('M', 'Migros', 'Marka Filmi', 5.0, 'Harika bir iş çıkardı.'),
      ('B', 'Beko', 'Reklam Filmi', 4.9, 'Çok profesyonel çalışma.'),
      ('A', 'Ajet', 'Tanıtım Filmi', 5.0, 'Kesinlikle tavsiye ederim.'),
      ('T', 'Türk Telekom', 'Kurumsal', 4.8, 'Zamanında ve kaliteli teslimat.'),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Text(
          'Yorumlar ($reviewCount)',
          style:
              AppTextStyles.heading3.copyWith(color: Colors.black87),
        ),
        const SizedBox(height: 14),
        ...dummyReviews.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ReviewItem(
                initials: r.$1,
                brand: r.$2,
                projectType: r.$3,
                rating: r.$4,
                comment: r.$5,
              ),
            )),
      ],
    );
  }
}

// ─── Review Item ──────────────────────────────────────────────────────────────

class _ReviewItem extends StatelessWidget {
  const _ReviewItem({
    required this.initials,
    required this.brand,
    required this.projectType,
    required this.rating,
    required this.comment,
  });

  final String initials;
  final String brand;
  final String projectType;
  final double rating;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE8D5C0),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: AppTextStyles.heading3.copyWith(
                  color: const Color(0xFF8D6E63), fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$brand ',
                      style: AppTextStyles.body2.copyWith(
                          fontWeight: FontWeight.w700, color: Colors.black87),
                    ),
                    Text(
                      projectType,
                      style:
                          AppTextStyles.body2.copyWith(color: Colors.black54),
                    ),
                    const Spacer(),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: i < rating.round()
                              ? const Color(0xFFE8B84B)
                              : Colors.black12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: AppTextStyles.caption.copyWith(
                          color: Colors.black87, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment,
                  style:
                      AppTextStyles.body2.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
