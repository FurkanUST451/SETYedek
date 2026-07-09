import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/project_model.dart';
import '../../../../widgets/set_card.dart';
import '../../../../widgets/set_chip.dart';
import '../../../../widgets/set_section_header.dart';
import '../freelancer_projects_controller.dart';

class FreelancerProjectsTab extends StatelessWidget {
  const FreelancerProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FreelancerProjectsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return SafeArea(
      bottom: false,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.loadProjects,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              120,
            ),
            children: [
              SetSectionHeader(
                eyebrow: 'WORKSPACE',
                title: 'Projelerim',
                description: 'Aktif ve tamamlanan işler',
                large: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              if (controller.projects.isEmpty)
                _EmptyState(secondaryColor: secondaryColor)
              else
                ...controller.projects.map((project) {
                  final active = project.status == ProjectStatus.active;
                  final statusLabel = _statusLabel(project.status);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: SetCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  project.title.isNotEmpty
                                      ? project.title
                                      : 'Proje',
                                  style: AppTextStyles.heading3,
                                ),
                              ),
                              SetChip(label: statusLabel, selected: active),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Icon(
                                Icons.attach_money_rounded,
                                size: 14,
                                color: secondaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${project.budget.toStringAsFixed(0)} ₺',
                                style: AppTextStyles.body2
                                    .copyWith(color: secondaryColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      }),
    );
  }

  String _statusLabel(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.active:
        return 'Aktif';
      case ProjectStatus.completed:
        return 'Tamamlandı';
      case ProjectStatus.cancelled:
        return 'İptal Edildi';
      case ProjectStatus.pending:
        return 'Bekliyor';
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.secondaryColor});

  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(Icons.folder_open_outlined, size: 40, color: secondaryColor),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Henüz proje yok',
            style: AppTextStyles.heading3.copyWith(color: secondaryColor),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Bir teklif kabul edildiğinde burada görünür.',
            style: AppTextStyles.body2.copyWith(color: secondaryColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
