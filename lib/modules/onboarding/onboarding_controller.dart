import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';

class OnboardingPageData {
  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  static const List<OnboardingPageData> pages = [
    OnboardingPageData(
      title: 'Doğru ekibi bul',
      subtitle:
          'Türkiye\'nin en yetenekli video prodüksiyon freelancer\'ları tek çatı altında.',
      icon: Icons.search,
    ),
    OnboardingPageData(
      title: 'Bütçeni kontrol et',
      subtitle:
          'Şeffaf teklifler ve net fiyatlandırma ile sürpriz yok.',
      icon: Icons.attach_money,
    ),
    OnboardingPageData(
      title: 'Projeni SET teslim etsin',
      subtitle:
          'Tam servis prodüksiyon istiyorsan ekibimiz işin başında.',
      icon: Icons.verified,
    ),
  ];

  bool get isLastPage => currentPage.value == pages.length - 1;

  void onPageChanged(int index) => currentPage.value = index;

  void next() {
    if (isLastPage) {
      finish();
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void skip() => finish();

  Future<void> finish() async {
    await StorageService.write(StorageService.onboardingComplete, true);
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
