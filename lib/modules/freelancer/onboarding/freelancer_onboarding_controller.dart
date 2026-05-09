import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/dummy/dummy_data.dart';
import '../../../routes/app_routes.dart';

class FreelancerOnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentStep = 0.obs;

  final RxnString selectedCategory = RxnString();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  static const totalSteps = 4;

  List<String> get categories => DummyData.categories;

  bool get isLastStep => currentStep.value == totalSteps - 1;

  void onPageChanged(int i) => currentStep.value = i;

  void selectCategory(String c) => selectedCategory.value = c;

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

  void finish() {
    Get.offAllNamed(AppRoutes.freelancerHome);
  }

  @override
  void onClose() {
    pageController.dispose();
    bioController.dispose();
    locationController.dispose();
    experienceController.dispose();
    super.onClose();
  }
}
