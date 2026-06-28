import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';

class ProjectModeView extends StatefulWidget {
  const ProjectModeView({super.key});

  @override
  State<ProjectModeView> createState() => _ProjectModeViewState();
}

class _ProjectModeViewState extends State<ProjectModeView> {
  // null = seçilmedi, 'freelancer' veya 'set'
  String? _selected;

  void _proceed() {
    if (_selected == null) return;
    final args = Get.arguments as Map<String, dynamic>?;
    final category = (args?['category'] as String?) ?? '';
    final briefId = (args?['briefId'] as String?) ?? '';
    if (_selected == 'set') {
      Get.toNamed(AppRoutes.chatDetail,
          arguments: {'name': 'SET Destek', 'mode': 'set'});
    } else {
      Get.toNamed(AppRoutes.freelancersByCategory,
          arguments: {'category': category, 'briefId': briefId});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.choosePageBg, fit: BoxFit.cover, cacheWidth: 1080),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.black87),
                        onPressed: () => Get.back(),
                      ),
                      const Spacer(),
                      Text(
                        'SET',
                        style: AppTextStyles.wordmark.copyWith(
                          color: Colors.black87,
                          fontSize: 22,
                          letterSpacing: 2,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Projene en uygun üretim sürecini seç.',
                          style: AppTextStyles.body2
                              .copyWith(color: Colors.black45),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Nasıl\nilerleyelim?',
                          style: AppTextStyles.displayXL.copyWith(
                            color: Colors.black87,
                            fontSize: 40,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Two cards
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Left — Freelancer Bul
                              Expanded(
                                child: _ModeCard(
                                  selected: _selected == 'freelancer',
                                  onTap: () =>
                                      setState(() => _selected = 'freelancer'),
                                  dark: false,
                                  child: _FreelancerCard(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Right — SET Halletsin
                              Expanded(
                                child: _ModeCard(
                                  selected: _selected == 'set',
                                  onTap: () =>
                                      setState(() => _selected = 'set'),
                                  dark: true,
                                  child: _SetCard(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Devam Et button
                        GestureDetector(
                          onTap: _proceed,
                          child: AnimatedOpacity(
                            opacity: _selected != null ? 1.0 : 0.45,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8B84B),
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Devam Et  →',
                                style: AppTextStyles.button.copyWith(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock_outline,
                                size: 12, color: Colors.black38),
                            const SizedBox(width: 5),
                            Text(
                              'Seçimin daha sonra değiştirilebilir.',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.black38,
                                fontSize: 11,
                              ),
                            ),
                          ],
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
    );
  }
}

// ─── Mode Card wrapper ────────────────────────────────────────────────────────

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.selected,
    required this.onTap,
    required this.dark,
    required this.child,
  });

  final bool selected;
  final VoidCallback onTap;
  final bool dark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF1A1200) : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? const Color(0xFFE8B84B)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? 0.3 : 0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

// ─── Left card content ────────────────────────────────────────────────────────

class _FreelancerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const freelancers = [
      ('Video Editor', '4.9'),
      ('Cinematographer', '4.8'),
      ('Colorist', '4.9'),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF0E8DC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.search_rounded,
                color: Color(0xFF8D6E63), size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            'Freelancer\nBul',
            style: AppTextStyles.heading2.copyWith(
              color: Colors.black87,
              fontSize: 18,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Kendi freelancer\'ını bul, projeni sen yönet.',
            style: AppTextStyles.caption.copyWith(
              color: Colors.black45,
              fontSize: 11,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          // Mini freelancer list
          ...freelancers.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5EBD8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline,
                          size: 14, color: Color(0xFF8D6E63)),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          f.$1,
                          style: AppTextStyles.caption.copyWith(
                              color: Colors.black87,
                              fontSize: 10,
                              fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.star_rounded,
                          size: 10, color: Color(0xFFE8B84B)),
                      Text(
                        ' ${f.$2}',
                        style: AppTextStyles.caption
                            .copyWith(fontSize: 10, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 12),
          // Bullets
          ...[
            'Binlerce freelancer profili',
            'Kendini seç, kendin yönet',
            'Esnek ve hızlı başlangıç',
          ].map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(
                            color: Color(0xFF8D6E63), fontSize: 11)),
                    Expanded(
                      child: Text(
                        b,
                        style: AppTextStyles.caption.copyWith(
                            color: Colors.black54, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ─── Right card content ───────────────────────────────────────────────────────

class _SetCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final checklist = [
      ('Ekibi Oluşturuyoruz', true),
      ('Planlıyoruz', true),
      ('Üretiyoruz', true),
      ('Teslim Ediyoruz', false),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SET logo chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'SET',
              style: AppTextStyles.button.copyWith(
                color: Colors.white,
                fontSize: 13,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'SET\nHalletsin',
            style: AppTextStyles.heading2.copyWith(
              color: Colors.white,
              fontSize: 18,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tüm prodüksiyon sürecini biz yönetelim, seninle sonuca odaklanalım.',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white54,
              fontSize: 11,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          // Checklist
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SÜREÇ YÖNETİMİ',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white38,
                    fontSize: 9,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                ...checklist.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: [
                          Icon(
                            item.$2
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            size: 13,
                            color: item.$2
                                ? const Color(0xFFE8B84B)
                                : Colors.white24,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item.$1,
                            style: AppTextStyles.caption.copyWith(
                              color: item.$2 ? Colors.white70 : Colors.white30,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Bullets
          ...[
            'Uzman ekibi biz kurarız',
            'Tüm süreci biz yönetiriz',
            'Zaman kazandırır, stressiz ilerler',
          ].map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(
                            color: Color(0xFFE8B84B), fontSize: 11)),
                    Expanded(
                      child: Text(
                        b,
                        style: AppTextStyles.caption.copyWith(
                            color: Colors.white38, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
