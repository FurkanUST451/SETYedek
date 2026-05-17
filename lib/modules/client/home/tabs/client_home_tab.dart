import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart' hide RadialGradient, LinearGradient;

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';

class ClientHomeTab extends StatefulWidget {
  const ClientHomeTab({super.key});

  @override
  State<ClientHomeTab> createState() => _ClientHomeTabState();
}

class _ClientHomeTabState extends State<ClientHomeTab> {
  OneShotAnimation? _pulseCtrl;
  bool _tapped = false;

  void _onRiveInit(Artboard artboard) {
    final ctrl = OneShotAnimation('Timeline 19', autoplay: false);
    artboard.addController(ctrl);
    _pulseCtrl = ctrl;
  }

  Future<void> _onButtonTap() async {
    if (_tapped) return;
    _tapped = true;
    _pulseCtrl?.isActive = true;
    await Future.delayed(const Duration(milliseconds: 550));
    if (mounted) {
      Get.toNamed(AppRoutes.categoryPicker);
      _tapped = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Golden radial glow — centered on button area
        Positioned.fill(
          child: Center(
            child: Container(
              width: 380,
              height: 380,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x55D4A843),
                    Color(0x22A07828),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Brand eyebrow
              Text(
                'SET',
                style: AppTextStyles.eyebrow.copyWith(
                  color: AppColors.accentGold,
                  fontSize: 13,
                  letterSpacing: 3,
                ),
              ),
              const Spacer(),
              // Bold title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Projeni başlat,\nduygusallıkla,\nyaratıcılıkla',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.displayXL.copyWith(
                    fontSize: 36,
                    height: 1.18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 52),
              // Circular button + Rive pulse
              GestureDetector(
                onTap: _onButtonTap,
                child: SizedBox(
                  width: 210,
                  height: 210,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Rive pulse animation — fills the container
                      RiveAnimation.asset(
                        'assets/animations/pulse.riv',
                        onInit: _onRiveInit,
                        fit: BoxFit.contain,
                      ),
                      // Gold circle
                      Container(
                        width: 136,
                        height: 136,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFD4A843),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD4A843)
                                  .withValues(alpha: 0.45),
                              blurRadius: 40,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.rocket_launch_outlined,
                              color: Color(0xFF1A1200),
                              size: 28,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Proje\nBaşlat',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.button.copyWith(
                                color: const Color(0xFF1A1200),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 44),
              // Light description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  'Danışmanlarınla iletişim kur,\nhız, güven ve yaratıcılıkla\nprojeni hayata geçir.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                    height: 1.65,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
