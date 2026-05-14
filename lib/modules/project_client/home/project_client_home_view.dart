import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../widgets/set_bottom_nav.dart';
import 'project_client_home_controller.dart';
import 'tabs/project_discover_tab.dart';
import 'tabs/project_settings_tab.dart';

class ProjectClientHomeView extends GetView<ProjectClientHomeController> {
  const ProjectClientHomeView({super.key});

  static const _tabs = <Widget>[
    ProjectDiscoverTab(),
    ProjectSettingsTab(),
  ];

  static const _navItems = <SetNavItem>[
    SetNavItem(icon: Icons.movie_outlined, label: AppStrings.tabDiscover),
    SetNavItem(icon: Icons.settings_outlined, label: AppStrings.tabSettings),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: _tabs,
          )),
      bottomNavigationBar: Obx(() => SetBottomNav(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            items: _navItems,
          )),
    );
  }
}
