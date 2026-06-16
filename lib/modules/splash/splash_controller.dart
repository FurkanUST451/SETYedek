import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_assets.dart';
import '../../data/models/user_model.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';


class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _decideInitialRoute();
  }

  Future<void> _decideInitialRoute() async {
    await Future.delayed(const Duration(seconds: 2));

    await StorageService.remove(StorageService.onboardingComplete);
    final hasOnboarded =
        StorageService.read<bool>(StorageService.onboardingComplete) ?? false;

    // Firebase'de oturum açık mı kontrol et
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final userId = firebaseUser?.uid ?? StorageService.read<String>(StorageService.userId);
    final roleName = StorageService.read<String>(StorageService.userRole);

    // Onboarding hiç gösterilmemişse oraya gönder
    if (!hasOnboarded) {
      await Future.wait([
        precacheImage(const AssetImage(AppAssets.welcomeBg1), Get.context!),
        precacheImage(const AssetImage(AppAssets.welcomeBg2), Get.context!),
        precacheImage(const AssetImage(AppAssets.welcomeBg3), Get.context!),
        precacheImage(const AssetImage(AppAssets.welcomeMascot1), Get.context!),
        precacheImage(const AssetImage(AppAssets.welcomeMascot2), Get.context!),
        precacheImage(const AssetImage(AppAssets.welcomeMascot3), Get.context!),
      ]);
      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }

    // Giriş yapılmamışsa auth seçim ekranına
    if (userId == null) {
      Get.offAllNamed(AppRoutes.chooseAuth);
      return;
    }

    // Rol seçilmemişse role selection'a
    if (roleName == null) {
      Get.offAllNamed(AppRoutes.roleSelection);
      return;
    }

    // Rol belirli → doğrudan home'a
    switch (UserRole.fromName(roleName)) {
      case UserRole.client:
        Get.offAllNamed(AppRoutes.clientHome);
      case UserRole.freelancer:
        Get.offAllNamed(AppRoutes.freelancerHome);
    }
  }
}
