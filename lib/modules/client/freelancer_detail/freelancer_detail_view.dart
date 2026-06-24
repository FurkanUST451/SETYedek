import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/freelancer_model.dart';
import '../../../widgets/video_viewer_page.dart';
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
                      headerSliverBuilder: (context, _) => [
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
                                  'Direktör · ${f?.categories.join(', ') ?? ''}',
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

  static const List<List<Color>> _warmPalettes = [
    [Color(0xFF5C4033), Color(0xFF8D6E63)],
    [Color(0xFF4A3728), Color(0xFF795548)],
    [Color(0xFF6D4C41), Color(0xFFA1887F)],
    [Color(0xFF3E2723), Color(0xFF6D4C41)],
  ];

  String? _youtubeId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    if (uri.host.contains('youtu.be')) return uri.pathSegments.firstOrNull;
    if (uri.host.contains('youtube.com')) {
      if (uri.pathSegments.contains('shorts') && uri.pathSegments.length > 1) {
        return uri.pathSegments[uri.pathSegments.indexOf('shorts') + 1];
      }
      return uri.queryParameters['v'];
    }
    return null;
  }

  String? _youtubeThumbnail(String url) {
    final id = _youtubeId(url);
    return id != null ? 'https://img.youtube.com/vi/$id/mqdefault.jpg' : null;
  }

  void _openVideo(String url, String title) {
    Navigator.of(Get.context!).push(
      MaterialPageRoute(
        builder: (_) => VideoViewerPage(videoUrl: url, title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projects = freelancer?.projects ?? [];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        Text(
          'Projeler',
          style: AppTextStyles.heading3.copyWith(color: Colors.black87),
        ),
        const SizedBox(height: 14),
        if (projects.isEmpty)
          Container(
            height: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Henüz proje eklenmemiş',
              style: AppTextStyles.body2.copyWith(color: Colors.black38),
            ),
          )
        else
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: projects.length,
              separatorBuilder: (context, i) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final p = projects[i];
                final videoUrl = p.videoUrl;
                final thumbnail = videoUrl != null ? _youtubeThumbnail(videoUrl) : null;
                final colors = _warmPalettes[i % _warmPalettes.length];

                return GestureDetector(
                  onTap: videoUrl != null ? () => _openVideo(videoUrl, p.title) : null,
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: colors,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // YouTube thumbnail (varsa)
                        if (thumbnail != null)
                          CachedNetworkImage(
                            imageUrl: thumbnail,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => const SizedBox.shrink(),
                          )
                        else if (videoUrl != null)
                          Container(
                            color: Colors.black.withValues(alpha: 0.2),
                            alignment: Alignment.center,
                            child: const Icon(Icons.videocam_outlined,
                                color: Colors.white54, size: 36),
                          ),
                        // Alt metin için karartma
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.7),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (p.title.isNotEmpty)
                                  Text(
                                    p.title,
                                    style: AppTextStyles.heading3.copyWith(
                                        color: Colors.white, fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                if (p.jobType.isNotEmpty)
                                  Text(
                                    p.jobType,
                                    style: AppTextStyles.caption.copyWith(
                                        color: Colors.white60, fontSize: 11),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // Oynat butonu (video varsa)
                        if (videoUrl != null)
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.45),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.play_arrow_rounded,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                      ],
                    ),
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
            ...(freelancer?.categories ?? []),
            'Color Grading',
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
