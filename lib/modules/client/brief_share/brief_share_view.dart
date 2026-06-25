import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_text_styles.dart';
import 'brief_share_controller.dart';

class BriefShareView extends GetView<BriefShareController> {
  const BriefShareView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                        icon: const Icon(Icons.arrow_back, color: Colors.black87),
                        onPressed: () => Get.back(),
                      ),
                      const Spacer(),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'SE',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                letterSpacing: 1,
                              ),
                            ),
                            TextSpan(
                              text: 'T',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFE8B84B),
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.category.isNotEmpty
                              ? controller.category
                              : 'Video Çekim',
                          style: AppTextStyles.caption
                              .copyWith(color: Colors.black45),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Brief'ini paylaş.",
                          style: AppTextStyles.displayXL.copyWith(
                            color: Colors.black87,
                            fontSize: 36,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Fikrini, referanslarını ve tüm detayları bizimle\npaylaş ki en doğru ekibi bulalım.',
                          style: AppTextStyles.body2
                              .copyWith(color: Colors.black45, height: 1.5),
                        ),
                        const SizedBox(height: 24),

                        // Brief card
                        _SectionCard(
                          icon: Icons.edit_outlined,
                          title: 'Kendi Brief\'ini Yaz',
                          subtitle:
                              'Projenin detaylarını, hedefini, istediğin tarzı ve özel notlarını yaz.',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 12),
                              Theme(
                                data: ThemeData(
                                  brightness: Brightness.light,
                                  inputDecorationTheme:
                                      const InputDecorationTheme(
                                    filled: true,
                                    fillColor: Color(0xFFF5ECD7),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                                child: TextField(
                                  controller: controller.briefText,
                                  maxLines: 7,
                                  maxLength: 2000,
                                  style: AppTextStyles.body2
                                      .copyWith(color: Colors.black87),
                                  decoration: InputDecoration(
                                    hintText: "Brief'ini buraya yaz...",
                                    hintStyle: AppTextStyles.body2.copyWith(
                                        color: Colors.black26),
                                    filled: true,
                                    fillColor: const Color(0xFFF5ECD7),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    counterText: '',
                                    isDense: true,
                                    contentPadding: const EdgeInsets.all(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Obx(() => Text(
                                    '${controller.charCount.value} / 2000',
                                    style: AppTextStyles.caption.copyWith(
                                        color: Colors.black38, fontSize: 11),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Pinned bottom section
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: controller.submit,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8B84B),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Brief'i Gönder  →",
                            style: AppTextStyles.button.copyWith(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_outline,
                              size: 12, color: Colors.black38),
                          const SizedBox(width: 5),
                          Text(
                            'Tüm dosyalar gizlidir ve sadece seçilen ekiplerle paylaşılır.',
                            style: AppTextStyles.caption.copyWith(
                                color: Colors.black38, fontSize: 10),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
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

// ─── Section Card ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0E8DC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF8D6E63), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.heading3
                          .copyWith(color: Colors.black87, fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                          color: Colors.black45, fontSize: 11, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
