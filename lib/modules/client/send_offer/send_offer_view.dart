import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_text_styles.dart';
import 'send_offer_controller.dart';

class SendOfferView extends GetView<SendOfferController> {
  const SendOfferView({super.key});

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
                                fontFamily: 'SpaceGrotesk',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                letterSpacing: 1,
                              ),
                            ),
                            TextSpan(
                              text: 'T',
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk',
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
                        // Category label
                        Text(
                          controller.category.isNotEmpty
                              ? controller.category
                              : 'Video Çekim',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.black45,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Headline
                        Text(
                          "Doğru brief'i\noluşturalım.",
                          style: AppTextStyles.displayXL.copyWith(
                            color: Colors.black87,
                            fontSize: 36,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Projene en uygun kreatif ekibi eşleştirelim.',
                          style: AppTextStyles.body2
                              .copyWith(color: Colors.black45),
                        ),
                        const SizedBox(height: 24),

                        // Çekim Türü
                        Obx(() => _BriefRow(
                              icon: Icons.movie_creation_outlined,
                              label: 'Çekim Türü',
                              value: controller.selectedShootingType.value,
                              onTap: () => _showPicker(
                                context,
                                title: 'Çekim Türü',
                                options: SendOfferController.shootingTypes,
                                selected: controller.selectedShootingType.value,
                                onSelect: (v) =>
                                    controller.selectedShootingType.value = v,
                              ),
                            )),
                        const SizedBox(height: 10),

                        // Duygu / Vibe
                        Obx(() => _BriefRow(
                              icon: Icons.show_chart_rounded,
                              label: 'Duygu / Vibe',
                              onTap: () => _showVibePicker(context),
                              child: Wrap(
                                spacing: 6,
                                children: SendOfferController.vibeOptions
                                    .where((v) =>
                                        controller.selectedVibes.contains(v))
                                    .map((v) => Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE8B84B),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            v,
                                            style: AppTextStyles.caption
                                                .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            )),
                        const SizedBox(height: 10),

                        // Çekim Aralığı
                        Obx(() => _BriefRow(
                              icon: Icons.calendar_month_outlined,
                              label: 'Çekim Aralığı',
                              value: controller.selectedDateRange.value,
                              onTap: () => _showPicker(
                                context,
                                title: 'Çekim Aralığı',
                                options: SendOfferController.dateRangeOptions,
                                selected: controller.selectedDateRange.value,
                                onSelect: (v) =>
                                    controller.selectedDateRange.value = v,
                              ),
                            )),
                        const SizedBox(height: 10),

                        // Teslim Süresi
                        Obx(() => _BriefRow(
                              icon: Icons.hourglass_empty_rounded,
                              label: 'Teslim Süresi',
                              value: controller.selectedDelivery.value,
                              onTap: () => _showPicker(
                                context,
                                title: 'Teslim Süresi',
                                options: SendOfferController.deliveryOptions,
                                selected: controller.selectedDelivery.value,
                                onSelect: (v) =>
                                    controller.selectedDelivery.value = v,
                              ),
                            )),
                        const SizedBox(height: 10),

                        // Bütçe Aralığı
                        Obx(() => _BriefRow(
                              icon: Icons.account_balance_wallet_outlined,
                              label: 'Bütçe Aralığı',
                              value: controller.selectedBudget.value,
                              onTap: () => _showPicker(
                                context,
                                title: 'Bütçe Aralığı',
                                options: SendOfferController.budgetOptions,
                                selected: controller.selectedBudget.value,
                                onSelect: (v) =>
                                    controller.selectedBudget.value = v,
                              ),
                            )),
                        const SizedBox(height: 10),

                        // Lokasyon
                        Obx(() => _BriefRow(
                              icon: Icons.location_on_outlined,
                              label: 'Lokasyon',
                              value: controller.selectedLocation.value,
                              onTap: () => _showPicker(
                                context,
                                title: 'Lokasyon',
                                options: SendOfferController.locationOptions,
                                selected: controller.selectedLocation.value,
                                onSelect: (v) =>
                                    controller.selectedLocation.value = v,
                              ),
                            )),

                        const SizedBox(height: 28),

                        // Devam Et button
                        Obx(() => GestureDetector(
                              onTap: controller.isSubmitting.value
                                  ? null
                                  : controller.submit,
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
                                child: controller.isSubmitting.value
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.4,
                                          color: Colors.black,
                                        ),
                                      )
                                    : Text(
                                        'Devam Et  →',
                                        style: AppTextStyles.button.copyWith(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            )),

                        const SizedBox(height: 14),
                        // Security note
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock_outline,
                                size: 12, color: Colors.black38),
                            const SizedBox(width: 5),
                            Text(
                              'Tüm bilgilerin güvenliği SET güvencesiyle korunur.',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.black38,
                                fontSize: 11,
                              ),
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

  void _showPicker(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String selected,
    required void Function(String) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF5EBD8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(title,
                style:
                    AppTextStyles.heading3.copyWith(color: Colors.black87)),
          ),
          ...options.map((o) => ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text(o,
                    style: AppTextStyles.body1.copyWith(color: Colors.black87)),
                trailing: o == selected
                    ? const Icon(Icons.check_rounded,
                        color: Color(0xFFE8B84B))
                    : null,
                onTap: () {
                  onSelect(o);
                  Navigator.pop(context);
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showVibePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF5EBD8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (_, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text('Duygu / Vibe',
                  style:
                      AppTextStyles.heading3.copyWith(color: Colors.black87)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              child: Obx(() => Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: SendOfferController.vibeOptions.map((v) {
                      final active = controller.selectedVibes.contains(v);
                      return GestureDetector(
                        onTap: () => controller.toggleVibe(v),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: active
                                ? const Color(0xFFE8B84B)
                                : Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: active
                                  ? const Color(0xFFE8B84B)
                                  : Colors.black12,
                            ),
                          ),
                          child: Text(
                            v,
                            style: AppTextStyles.button.copyWith(
                              color: active ? Colors.black : Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Brief Row ────────────────────────────────────────────────────────────────

class _BriefRow extends StatelessWidget {
  const _BriefRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
    this.child,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: const Color(0xFF8D6E63)),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.black45,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right,
                    color: Colors.black38, size: 20),
              ],
            ),
            if (value != null && value!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(
                  value!,
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            if (child != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: child!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
