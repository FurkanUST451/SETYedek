import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/set_button.dart';
import '../../../widgets/set_text_field.dart';
import 'project_onboarding_controller.dart';

class ProjectOnboardingView extends GetView<ProjectOnboardingController> {
  const ProjectOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projeni SET Yapsın')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Obx(() => _StepBar(
                    total: ProjectOnboardingController.totalSteps,
                    current: controller.currentStep.value,
                  )),
            ),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _VideoTypeStep(),
                  _BudgetStep(),
                  _BriefStep(controller: controller),
                  _DeadlineStep(controller: controller),
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
                          text: controller.isLastStep ? 'Gönder' : 'İleri',
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

class _StepBar extends StatelessWidget {
  const _StepBar({required this.total, required this.current});
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

class _VideoTypeStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProjectOnboardingController>();
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ne çekiyoruz?', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: Obx(() => ListView.separated(
                  itemCount: ProjectOnboardingController.videoTypes.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (_, i) {
                    final t = ProjectOnboardingController.videoTypes[i];
                    final selected = c.videoType.value == t;
                    return InkWell(
                      onTap: () => c.videoType.value = t,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary.withValues(alpha: 0.18)
                              : AppColors.surfaceDark,
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Text(t, style: AppTextStyles.body1),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}

class _BudgetStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProjectOnboardingController>();
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bütçen ne aralıkta?', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.lg),
          Obx(() => Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: ProjectOnboardingController.budgets.map((b) {
                  final selected = c.budgetRange.value == b;
                  return GestureDetector(
                    onTap: () => c.budgetRange.value = b,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withValues(alpha: 0.18)
                            : AppColors.surfaceDark,
                        border: Border.all(
                          color:
                              selected ? AppColors.primary : AppColors.border,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(b, style: AppTextStyles.body1),
                    ),
                  );
                }).toList(),
              )),
        ],
      ),
    );
  }
}

class _BriefStep extends StatelessWidget {
  const _BriefStep({required this.controller});
  final ProjectOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SetTextField(
        label: 'Kısa brief',
        hint: 'Projenin amacı, hedef kitlesi, tonu...',
        controller: controller.briefController,
        maxLines: 8,
      ),
    );
  }
}

class _DeadlineStep extends StatelessWidget {
  const _DeadlineStep({required this.controller});
  final ProjectOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SetTextField(
        label: 'Son teslim tarihi',
        hint: 'GG/AA/YYYY',
        controller: controller.deadlineController,
      ),
    );
  }
}
