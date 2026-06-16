import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/freelancer_model.dart';
import '../../../data/models/user_model.dart';
import 'freelancers_by_category_controller.dart';

class FreelancersByCategoryView
    extends GetView<FreelancersByCategoryController> {
  const FreelancersByCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final list = controller.freelancers;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.choosePageBg, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    padding: EdgeInsets.zero,
                  ),
                ),
                // Headline
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'uygun ${list.isEmpty ? 0 : list.length * 10} kreatif.',
                        style: AppTextStyles.displayXL.copyWith(
                          color: Colors.black87,
                          fontSize: 38,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '5 kişiye ücretsiz teklif gönder.\nFazlası için kredi gerekir.',
                        style: AppTextStyles.body2.copyWith(
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Selection counter chip
                      Obx(() => Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${controller.selectedIds.length}/5 seçildi',
                                  style: AppTextStyles.heading3.copyWith(
                                    color: Colors.black87,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Öne çıkan işlere bak, doğru ekibi seç',
                                  style: AppTextStyles.body2.copyWith(
                                    color: Colors.black45,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
                // List
                Expanded(
                  child: list.isEmpty
                      ? _EmptyState(category: controller.category)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          itemCount: list.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) {
                            final f = list[i];
                            return Obx(() => _FreelancerCard(
                                  freelancer: f,
                                  user: controller.userFor(f),
                                  selected: controller.isSelected(f),
                                  onProfile: () => controller.openDetail(f),
                                  onInvite: () => controller.toggleSelect(f),
                                ));
                          },
                        ),
                ),
              ],
            ),
          ),
          // Bottom CTA
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Obx(() {
              final count = controller.selectedIds.length;
              return GestureDetector(
                onTap: controller.sendOffers,
                child: AnimatedOpacity(
                  opacity: count > 0 ? 1.0 : 0.45,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8B84B),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Seçilenlere Teklif Gönder  →',
                      style: AppTextStyles.button.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _FreelancerCard extends StatelessWidget {
  const _FreelancerCard({
    required this.freelancer,
    required this.user,
    required this.selected,
    required this.onProfile,
    required this.onInvite,
  });

  final FreelancerModel freelancer;
  final UserModel user;
  final bool selected;
  final VoidCallback onProfile;
  final VoidCallback onInvite;

  int get _jobCount => freelancer.experience * 12 + 15;
  int get _trustScore => (freelancer.rating * 19.5).round();

  List<List<Color>> _thumbColors() {
    final seed = freelancer.userId.codeUnits.fold(0, (a, b) => a + b);
    const palettes = [
      [Color(0xFFBCAA99), Color(0xFF8D7B6A)],
      [Color(0xFF9E8B7A), Color(0xFF6D5C4A)],
      [Color(0xFFD4B896), Color(0xFFA08060)],
      [Color(0xFF7A6A5A), Color(0xFF5A4A3A)],
      [Color(0xFFC4A882), Color(0xFF8A6A4A)],
      [Color(0xFF8A7060), Color(0xFF6A5040)],
    ];
    return [
      palettes[seed % palettes.length],
      palettes[(seed + 2) % palettes.length],
      palettes[(seed + 4) % palettes.length],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final thumbColors = _thumbColors();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar placeholder
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8D5C0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: Color(0xFF8D6E63),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: AppTextStyles.heading3.copyWith(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Direktör · ${freelancer.category}',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${freelancer.location}, Türkiye · ${freelancer.experience} Yıl',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.black45,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Stat chips
                    Wrap(
                      spacing: 6,
                      children: [
                        _Chip(label: freelancer.rating.toStringAsFixed(1)),
                        _Chip(label: '$_jobCount iş'),
                        _Chip(label: 'Trust $_trustScore'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Portfolio thumbnails
          Row(
            children: List.generate(3, (i) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: thumbColors[i],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onProfile,
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Profili Gör',
                      style: AppTextStyles.button.copyWith(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: onInvite,
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFE8B84B)
                          : Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      selected ? 'Seçildi ✓' : 'Davet Et',
                      style: AppTextStyles.button.copyWith(
                        color: selected ? Colors.black : Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0E8DC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded, size: 56, color: Colors.black26),
          const SizedBox(height: 16),
          Text(
            '"$category" alanında\nhenüz kreatif yok',
            style: AppTextStyles.heading3.copyWith(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
