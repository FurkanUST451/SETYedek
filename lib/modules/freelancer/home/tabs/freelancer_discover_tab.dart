import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../client/home/tabs/client_discover_tab.dart';

const _kInk = Color(0xFF35333F);
const _kGold = Color(0xFFD9A84E);

/// Keşfet, hem hizmet alan hem hizmet veren için aynı ortak SET akışıdır
/// (herkesin son işlerini gösteren tek bir vitrin) — bu yüzden aynı
/// ekranı birebir yeniden kullanıyoruz. Freelancer tarafında ek olarak
/// sağ altta portföy projesi yüklemek için bir buton bulunur.
class FreelancerDiscoverTab extends StatelessWidget {
  const FreelancerDiscoverTab({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final double s = (width / 390).clamp(0.85, 1.15).toDouble();
    final navClearance = 60 + MediaQuery.paddingOf(context).bottom;

    return Stack(
      children: [
        const ClientDiscoverTab(),
        Positioned(
          right: 20 * s,
          bottom: navClearance + 20 * s,
          child: GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.freelancerUploadWork),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 52 * s,
              height: 52 * s,
              decoration: BoxDecoration(
                color: _kInk,
                border: Border.all(color: _kGold, width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.add_rounded, size: 26 * s, color: _kGold),
            ),
          ),
        ),
      ],
    );
  }
}
