import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_text_styles.dart';
import 'category_picker_controller.dart';

class CategoryPickerView extends GetView<CategoryPickerController> {
  const CategoryPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.choosePageBg, fit: BoxFit.cover, cacheWidth: 1080),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                // Top row: back + logo
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black87),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    Text(
                      'SET',
                      style: AppTextStyles.wordmark.copyWith(
                        color: Colors.black87,
                        letterSpacing: 2,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Hizmetini seç,',
                  style: AppTextStyles.heading1.copyWith(
                    color: Colors.black87,
                    fontSize: 26,
                  ),
                ),
                Text(
                  'fikrni hayata geçirelim.',
                  style: AppTextStyles.heading1.copyWith(
                    color: Colors.black54,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.black38,
                  size: 28,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    itemCount: controller.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final cat = controller.categories[i];
                      return _CategoryCard(
                        label: cat,
                        gradient: _gradientFor(i),
                        onTap: () => controller.selectCategory(cat),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _gradientFor(int index) {
    const gradients = [
      LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF5C4033), Color(0xFF8D6E63)],
      ),
      LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF6D4C41), Color(0xFFA1887F)],
      ),
      LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF795548), Color(0xFFBCAAA4)],
      ),
      LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF4E342E), Color(0xFF8D6E63)],
      ),
      LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF3E2723), Color(0xFF6D4C41)],
      ),
      LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF5D4037), Color(0xFF8D6E63)],
      ),
    ];
    return gradients[index % gradients.length];
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  final String label;
  final LinearGradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: AppTextStyles.heading2.copyWith(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
