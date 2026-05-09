import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/set_button.dart';
import '../../../widgets/set_text_field.dart';
import 'freelancer_onboarding_controller.dart';

class FreelancerOnboardingView extends GetView<FreelancerOnboardingController> {
  const FreelancerOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Freelancer Profili')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Obx(() => _StepIndicator(
                    total: FreelancerOnboardingController.totalSteps,
                    current: controller.currentStep.value,
                  )),
            ),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _CategoryStep(),
                  _BioStep(controller: controller),
                  _DetailsStep(controller: controller),
                  const _ReviewStep(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Obx(() => controller.currentStep.value > 0
                      ? Expanded(
                          child: SetButton(
                            text: 'Geri',
                            variant: SetButtonVariant.outline,
                            onPressed: controller.previous,
                          ),
                        )
                      : const SizedBox.shrink()),
                  Obx(() => controller.currentStep.value > 0
                      ? const SizedBox(width: AppSpacing.md)
                      : const SizedBox.shrink()),
                  Expanded(
                    child: Obx(() => SetButton(
                          text: controller.isLastStep ? 'Bitir' : 'İleri',
                          onPressed: controller.next,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.total, required this.current});
  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final active = i <= current;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 6,
            decoration: BoxDecoration(
              color: active ? AppColors.primary : AppColors.border,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
        );
      }),
    );
  }
}

class _CategoryStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<FreelancerOnboardingController>();
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kategorin nedir?', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: Obx(() => GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  children: c.categories.map((cat) {
                    final selected = c.selectedCategory.value == cat;
                    return GestureDetector(
                      onTap: () => c.selectCategory(cat),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary.withValues(alpha: 0.18)
                              : AppColors.surfaceDark,
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        alignment: Alignment.center,
                        child: Text(cat, style: AppTextStyles.body1),
                      ),
                    );
                  }).toList(),
                )),
          ),
        ],
      ),
    );
  }
}

class _BioStep extends StatelessWidget {
  const _BioStep({required this.controller});
  final FreelancerOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kendinden bahset', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.lg),
          SetTextField(
            label: 'Kısa biyografi',
            hint: 'Hangi işlere odaklanıyorsun?',
            controller: controller.bioController,
            maxLines: 6,
          ),
        ],
      ),
    );
  }
}

class _DetailsStep extends StatelessWidget {
  const _DetailsStep({required this.controller});
  final FreelancerOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          SetTextField(
            label: 'Lokasyon',
            hint: 'Şehir',
            controller: controller.locationController,
          ),
          const SizedBox(height: AppSpacing.md),
          SetTextField(
            label: 'Deneyim (yıl)',
            hint: '0',
            controller: controller.experienceController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hazırsın!', style: AppTextStyles.heading2),
          SizedBox(height: AppSpacing.md),
          Text(
            'Profilini yayına alıp ilk işini almaya başlayabilirsin.',
            style: AppTextStyles.body1,
          ),
        ],
      ),
    );
  }
}
