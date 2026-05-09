import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/storage_service.dart';

class ThemeController extends GetxController {
  final Rx<ThemeMode> _mode = ThemeMode.dark.obs;

  ThemeMode get mode => _mode.value;
  bool get isDark => _mode.value == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  void _loadFromStorage() {
    final stored = StorageService.read<String>(StorageService.themeMode);
    if (stored == 'light') {
      _mode.value = ThemeMode.light;
    } else if (stored == 'system') {
      _mode.value = ThemeMode.system;
    } else {
      _mode.value = ThemeMode.dark;
    }
    Get.changeThemeMode(_mode.value);
  }

  Future<void> setMode(ThemeMode mode) async {
    _mode.value = mode;
    Get.changeThemeMode(mode);
    await StorageService.write(StorageService.themeMode, mode.name);
  }

  Future<void> toggle() async {
    await setMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}
