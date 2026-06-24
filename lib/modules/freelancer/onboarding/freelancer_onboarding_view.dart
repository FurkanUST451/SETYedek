  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/freelancer_model.dart';
import '../../../widgets/set_button.dart';
import '../../../widgets/set_text_field.dart';
import 'freelancer_onboarding_controller.dart';

class FreelancerOnboardingView extends GetView<FreelancerOnboardingController> {
  const FreelancerOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  _PersonalInfoStep(),
                  _CategoryStep(),
                  _BioStep(controller: controller),
                  _PortfolioStep(controller: controller),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Row(
                  children: [
                    if (controller.currentStep.value > 0) ...[
                      Expanded(
                        child: SetButton(
                          text: 'Geri',
                          variant: SetButtonVariant.outline,
                          onPressed: controller.previous,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                    ],
                    Expanded(
                      child: SetButton(
                        text: controller.isLastStep ? 'Bitir' : 'Devam Et',
                        onPressed: controller.next,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step Indicator ──────────────────────────────────────────────────────────

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

// ─── Step 0: Personal Info ───────────────────────────────────────────────────

class _PersonalInfoStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<FreelancerOnboardingController>();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kişisel Bilgiler', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.lg),

          // Profil Fotoğrafı
          Center(
            child: Obx(() {
              final file = c.profileImageFile.value;
              return GestureDetector(
                onTap: c.pickProfileImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: AppColors.surfaceDark,
                      backgroundImage:
                          file != null ? FileImage(file) : null,
                      child: file == null
                          ? const Icon(
                              Icons.person_outline,
                              size: 48,
                              color: AppColors.textTertiary,
                            )
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Ad + Soyad
          Row(
            children: [
              Expanded(
                child: SetTextField(
                  label: 'Ad',
                  hint: 'Adın',
                  controller: c.nameController,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: SetTextField(
                  label: 'Soyad',
                  hint: 'Soyadın',
                  controller: c.surnameController,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Doğum Tarihi
          Obx(() => GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: c.birthDate.value ?? DateTime(1995, 1, 1),
                    firstDate: DateTime(1940),
                    lastDate: DateTime.now()
                        .subtract(const Duration(days: 365 * 16)),
                  );
                  if (picked != null) c.setBirthDate(picked);
                },
                child: AbsorbPointer(
                  child: SetTextField(
                    label: 'Doğum Tarihi',
                    hint: 'GG.AA.YYYY',
                    controller:
                        TextEditingController(text: c.formattedBirthDate),
                    suffixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              )),
          const SizedBox(height: AppSpacing.md),

          // Şehir
          Obx(() => GestureDetector(
                onTap: () => _showCityPicker(context, c),
                child: AbsorbPointer(
                  child: SetTextField(
                    label: 'Yaşadığı Şehir',
                    hint: 'Şehir seçin',
                    controller:
                        TextEditingController(text: c.selectedCity.value ?? ''),
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              )),
          const SizedBox(height: AppSpacing.md),

          // Deneyim Yılı
          Obx(() => GestureDetector(
                onTap: () => _showExperiencePicker(context, c),
                child: AbsorbPointer(
                  child: SetTextField(
                    label: 'Deneyim Yılı',
                    hint: '0 yıl',
                    controller: TextEditingController(
                      text: c.selectedExperience.value == 0
                          ? '0 yıl'
                          : '${c.selectedExperience.value} yıl',
                    ),
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void _showCityPicker(
      BuildContext context, FreelancerOnboardingController c) {
    final searchCtrl = TextEditingController();
    final filtered = ValueNotifier<List<String>>(
        FreelancerOnboardingController.turkishCities);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: Column(
          children: [
            _BottomSheetHandle(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Text('Şehir Seçin', style: AppTextStyles.heading3),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: TextField(
                controller: searchCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Şehir ara...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                ),
                onChanged: (val) {
                  filtered.value = FreelancerOnboardingController.turkishCities
                      .where((city) =>
                          city.toLowerCase().contains(val.toLowerCase()))
                      .toList();
                },
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: ValueListenableBuilder<List<String>>(
                valueListenable: filtered,
                builder: (_, cities, _) => ListView.builder(
                  itemCount: cities.length,
                  itemBuilder: (_, i) => ListTile(
                    title: Text(cities[i], style: AppTextStyles.body1),
                    onTap: () {
                      c.selectedCity.value = cities[i];
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExperiencePicker(
      BuildContext context, FreelancerOnboardingController c) {
    int tempValue = c.selectedExperience.value;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: Column(
          children: [
            _BottomSheetHandle(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text('Deneyim Yılı', style: AppTextStyles.heading3),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 48,
                scrollController: FixedExtentScrollController(
                    initialItem: c.selectedExperience.value),
                onSelectedItemChanged: (i) => tempValue = i,
                children: List.generate(
                  21,
                  (i) => Center(
                    child: Text(
                      i == 0 ? '0 yıl' : '$i yıl',
                      style: AppTextStyles.body1,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SizedBox(
                width: double.infinity,
                child: SetButton(
                  text: 'Seç',
                  onPressed: () {
                    c.selectedExperience.value = tempValue;
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 1: Categories ───────────────────────────────────────────────────────

class _CategoryStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<FreelancerOnboardingController>();
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kategoriler', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Birden fazla seçebilirsin',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: SingleChildScrollView(
              child: Obx(() => Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: c.categories.map((cat) {
                      final selected = c.selectedCategories.contains(cat);
                      return GestureDetector(
                        onTap: () => c.toggleCategory(cat),
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
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            cat,
                            style: AppTextStyles.body2.copyWith(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step 2: Bio ─────────────────────────────────────────────────────────────

class _BioStep extends StatelessWidget {
  const _BioStep({required this.controller});
  final FreelancerOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kendini kısaca tanıt:', style: AppTextStyles.heading2),
            const SizedBox(height: AppSpacing.lg),
            SetTextField(
              label: '',
              hint: 'Neler yapıyorsun, hangi işlere odaklanıyorsun?',
              controller: controller.bioController,
              maxLines: 8,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 3: Portfolio ────────────────────────────────────────────────────────

class _PortfolioStep extends StatelessWidget {
  const _PortfolioStep({required this.controller});
  final FreelancerOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final projects = controller.addedProjects;
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('Bize projelerinden bahset', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Bize daha önce yaptığın projelerden bahseder misin?',
            style:
                AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '(Profil kısmından projelerini eklemeye devam edebilirsin)',
            style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Eklenen proje kartları
          ...projects.asMap().entries.map((entry) {
            final i = entry.key;
            final p = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _ProjectCard(
                project: p,
                onDelete: () => controller.removeProject(i),
              ),
            );
          }),

          // + Buton
          _AddProjectButton(
            onTap: () => _showAddProjectSheet(context, controller),
          ),
        ],
      );
    });
  }

  void _showAddProjectSheet(
      BuildContext context, FreelancerOnboardingController c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddProjectSheet(onAdd: c.addProject),
    );
  }
}

// ─── Proje Kartı ─────────────────────────────────────────────────────────────

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.onDelete});
  final PortfolioProject project;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (project.title.isNotEmpty)
                  Text(project.title,
                      style: AppTextStyles.body1
                          .copyWith(fontWeight: FontWeight.w600)),
                if (project.jobType.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(project.jobType,
                      style: AppTextStyles.body2
                          .copyWith(color: AppColors.textSecondary)),
                ],
                if (project.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(project.description,
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textTertiary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
                if (project.videoUrl != null && project.videoUrl!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Icon(Icons.play_circle_outline,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          project.videoUrl!,
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.primary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.close, size: 18),
            color: AppColors.textTertiary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

// ─── + Buton ─────────────────────────────────────────────────────────────────

class _AddProjectButton extends StatelessWidget {
  const _AddProjectButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorderContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Proje Ekle',
              style:
                  AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class DottedBorderContainer extends StatelessWidget {
  const DottedBorderContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md, horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: child,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    const radius = Radius.circular(AppRadius.lg);

    final rRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), radius);
    final path = Path()..addRRect(rRect);

    final metric = path.computeMetrics().first;
    double distance = 0;
    while (distance < metric.length) {
      canvas.drawPath(
        metric.extractPath(distance, distance + dashWidth),
        paint,
      );
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Proje Ekleme Modal ───────────────────────────────────────────────────────

class _AddProjectSheet extends StatefulWidget {
  const _AddProjectSheet({required this.onAdd});
  final void Function(PortfolioProject) onAdd;

  @override
  State<_AddProjectSheet> createState() => _AddProjectSheetState();
}

class _AddProjectSheetState extends State<_AddProjectSheet> {
  final _titleCtrl = TextEditingController();
  final _jobTypeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _videoUrlCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _jobTypeCtrl.dispose();
    _descCtrl.dispose();
    _videoUrlCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleCtrl.text.trim().isEmpty && _jobTypeCtrl.text.trim().isEmpty) {
      return;
    }
    widget.onAdd(PortfolioProject(
      title: _titleCtrl.text.trim(),
      jobType: _jobTypeCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      videoUrl: _videoUrlCtrl.text.trim().isEmpty ? null : _videoUrlCtrl.text.trim(),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, bottom + AppSpacing.lg),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: _BottomSheetHandle()),
            const SizedBox(height: AppSpacing.sm),
            Text('Proje Ekle', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.lg),
            SetTextField(
              label: 'Proje Başlığı',
              hint: 'Migros',
              controller: _titleCtrl,
            ),
            const SizedBox(height: AppSpacing.md),
            SetTextField(
              label: 'İş Tanımı',
              hint: 'Reklam filmi',
              controller: _jobTypeCtrl,
            ),
            const SizedBox(height: AppSpacing.md),
            SetTextField(
              label: 'Kısa Açıklama',
              hint: 'Projeni kısaca anlat...',
              controller: _descCtrl,
              maxLines: 4,
            ),
            const SizedBox(height: AppSpacing.md),
            SetTextField(
              label: 'Video Linki',
              hint: 'YouTube, Vimeo veya doğrudan video URL\'i',
              controller: _videoUrlCtrl,
              suffixIcon: const Icon(
                Icons.play_circle_outline,
                size: 20,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: SetButton(text: 'Ekle', onPressed: _submit),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Ortak Yardımcı ───────────────────────────────────────────────────────────

class _BottomSheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xs),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
    );
  }
}
