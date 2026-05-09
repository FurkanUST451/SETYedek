import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class ProjectOnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentStep = 0.obs;

  final RxnString videoType = RxnString();
  final RxnString budgetRange = RxnString();
  final TextEditingController briefController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();

  static const totalSteps = 4;
  static const videoTypes = [
    'Reklam Filmi',
    'Marka Filmi',
    'Sosyal Medya',
    'Müzik Videosu',
    'Belgesel',
    'Diğer',
  ];
  static const budgets = ['< ₺10K', '₺10K-25K', '₺25K-50K', '₺50K+'];

  bool get isLastStep => currentStep.value == totalSteps - 1;

  void onPageChanged(int i) => currentStep.value = i;

  void next() {
    if (isLastStep) {
      finish();
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  void previous() {
    if (currentStep.value == 0) return;
    pageController.previousPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  void finish() => Get.offAllNamed(AppRoutes.projectClientHome);

  @override
  void onClose() {
    pageController.dispose();
    briefController.dispose();
    deadlineController.dispose();
    super.onClose();
  }
}
