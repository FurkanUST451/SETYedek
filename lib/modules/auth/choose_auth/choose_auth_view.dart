import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../routes/app_routes.dart';

class ChooseAuthView extends StatelessWidget {
  const ChooseAuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.choosePageBg, fit: BoxFit.cover),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(),
                  Image.asset(AppAssets.loginLogo, height: 80),
                  const SizedBox(height: 28),
                  const Text(
                    'Tüm kreatif süreçler.\nTek yerde.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      height: 1.35,
                    ),
                  ),
                  const Spacer(),
                  _AuthButton(
                    label: 'Google ile devam et',
                    icon: AppAssets.loginGoogle,
                    onTap: () {},
                    dark: false,
                  ),
                  const SizedBox(height: 12),
                  _AuthButton(
                    label: 'Apple ile devam et',
                    icon: AppAssets.loginApple,
                    onTap: () {},
                    dark: true,
                  ),
                  const SizedBox(height: 12),
                  _AuthButton(
                    label: 'E-posta ile devam et',
                    icon: AppAssets.loginEmail,
                    onTap: () => Get.toNamed(AppRoutes.login),
                    dark: false,
                  ),
                  const SizedBox(height: 28),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Misafir olarak devam et',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.dark,
  });

  final String label;
  final String icon;
  final VoidCallback onTap;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: dark ? Colors.black : Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(32),
          border: dark ? null : Border.all(color: Colors.black12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, height: 22, width: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: dark ? Colors.white : Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
