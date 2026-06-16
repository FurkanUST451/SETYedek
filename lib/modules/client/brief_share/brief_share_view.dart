import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_text_styles.dart';
import 'brief_share_controller.dart';

class BriefShareView extends GetView<BriefShareController> {
  const BriefShareView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.black87),
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

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category + headline
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

                        // ── Kendi Brief'ini Yaz ──────────────────────────
                        _SectionCard(
                          icon: Icons.edit_outlined,
                          title: 'Kendi Brief\'ini Yaz',
                          subtitle:
                              'Projenin detaylarını, hedefini, istediğin tarzı ve özel notlarını yaz.',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white
                                      .withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: TextField(
                                  controller: controller.briefText,
                                  maxLines: 6,
                                  maxLength: 2000,
                                  style: AppTextStyles.body2
                                      .copyWith(color: Colors.black87),
                                  decoration: InputDecoration(
                                    hintText: "Brief'ini buraya yaz...",
                                    hintStyle: AppTextStyles.body2.copyWith(
                                        color: Colors.black26),
                                    border: InputBorder.none,
                                    counterText: '',
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Obx(() => Text(
                                    '${controller.charCount.value} / 2000',
                                    style: AppTextStyles.caption.copyWith(
                                        color: Colors.black38, fontSize: 11),
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ── Sesli Not Bırak ──────────────────────────────
                        _SectionCard(
                          icon: Icons.mic_none_rounded,
                          title: 'Sesli Not Bırak',
                          subtitle:
                              'Fikrini sesli anlat, notlarını kolayca paylaş.',
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Obx(() => _VoiceRecorder(
                                  isRecording: controller.isRecording.value,
                                  time: controller.formattedTime,
                                  onToggle: controller.toggleRecording,
                                )),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Brief'i Gönder button
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
                                  color:
                                      Colors.black.withValues(alpha: 0.15),
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
                        const SizedBox(height: 12),
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
                      style: AppTextStyles.heading3.copyWith(
                          color: Colors.black87, fontSize: 15),
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

// ─── Voice Recorder ───────────────────────────────────────────────────────────

class _VoiceRecorder extends StatelessWidget {
  const _VoiceRecorder({
    required this.isRecording,
    required this.time,
    required this.onToggle,
  });

  final bool isRecording;
  final String time;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Timer
        Text(
          time,
          style: AppTextStyles.heading3.copyWith(
            color: Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        // Waveform placeholder
        Expanded(
          child: SizedBox(
            height: 28,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(22, (i) {
                final heights = [
                  4.0, 10.0, 6.0, 14.0, 8.0, 18.0, 10.0, 14.0,
                  6.0, 10.0, 4.0, 8.0, 14.0, 6.0, 18.0, 10.0,
                  6.0, 14.0, 8.0, 10.0, 4.0, 6.0,
                ];
                return AnimatedContainer(
                  duration: Duration(milliseconds: 200 + i * 20),
                  width: 2.5,
                  height: isRecording
                      ? heights[i % heights.length]
                      : heights[i % heights.length] * 0.5,
                  decoration: BoxDecoration(
                    color: isRecording
                        ? const Color(0xFFE8B84B)
                        : Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Record button
        GestureDetector(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isRecording
                  ? const Color(0xFFE53935)
                  : const Color(0xFFE53935).withValues(alpha: 0.85),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE53935)
                      .withValues(alpha: isRecording ? 0.4 : 0.2),
                  blurRadius: isRecording ? 20 : 8,
                  spreadRadius: isRecording ? 3 : 0,
                ),
              ],
            ),
            child: Icon(
              isRecording ? Icons.stop_rounded : Icons.fiber_manual_record,
              color: Colors.white,
              size: isRecording ? 22 : 20,
            ),
          ),
        ),
      ],
    );
  }
}
