import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'send_offer_controller.dart';

class SendOfferView extends GetView<SendOfferController> {
  const SendOfferView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Project Details',
          style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Text(
              'Tell us about\nyour project',
              style: AppTextStyles.editorialDisplay.copyWith(
                color: AppColors.textPrimary,
                fontSize: 42,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "We'll craft the perfect production plan for you.",
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Project Title field
            _DarkField(
              hint: 'Project Title',
              controller: controller.titleController,
              maxLines: 1,
            ),
            const SizedBox(height: AppSpacing.sm),

            // Description field
            _DarkField(
              hint: 'Describe your vision...',
              controller: controller.descriptionController,
              maxLines: 4,
            ),
            const SizedBox(height: AppSpacing.sm),

            // Budget Range
            Obx(() => _SelectorRow(
                  label: 'Budget Range',
                  value: controller.selectedBudget.value.isEmpty
                      ? '\$\$\$'
                      : controller.selectedBudget.value,
                  onTap: () => _showPicker(
                    context,
                    title: 'Budget Range',
                    options: SendOfferController.budgetOptions,
                    onSelect: (v) => controller.selectedBudget.value = v,
                  ),
                )),
            const SizedBox(height: AppSpacing.sm),

            // Timeline
            Obx(() => _SelectorRow(
                  label: 'Timeline',
                  value: controller.selectedTimeline.value.isEmpty
                      ? 'Select'
                      : controller.selectedTimeline.value,
                  onTap: () => _showPicker(
                    context,
                    title: 'Timeline',
                    options: SendOfferController.timelineOptions,
                    onSelect: (v) => controller.selectedTimeline.value = v,
                  ),
                )),
            const SizedBox(height: AppSpacing.xxl),

            // Mic + attachment row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Attachment
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: AppColors.border, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.attach_file_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                const Spacer(),
                // Golden mic button
                Column(
                  children: [
                    Obx(() => GestureDetector(
                          onLongPressStart: (_) =>
                              controller.isRecording.value = true,
                          onLongPressEnd: (_) =>
                              controller.isRecording.value = false,
                          child: _MicButton(
                              isRecording: controller.isRecording.value),
                        )),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Hold to record\na voice note',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const Spacer(),
                // Spacer mirror for attachment
                const SizedBox(width: 44),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Devam et button
            Obx(() => GestureDetector(
                  onTap: controller.isSubmitting.value
                      ? null
                      : controller.submit,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.accentGold,
                      borderRadius:
                          BorderRadius.circular(AppRadius.full),
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
                            'Devam Et',
                            style: AppTextStyles.button.copyWith(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _showPicker(
    BuildContext context, {
    required String title,
    required List<String> options,
    required void Function(String) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(title, style: AppTextStyles.heading3),
          ),
          ...options.map((o) => ListTile(
                title: Text(o, style: AppTextStyles.body1),
                onTap: () {
                  onSelect(o);
                  Navigator.pop(context);
                },
              )),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

// ─── Dark Input Field ────────────────────────────────────────────────────────

class _DarkField extends StatelessWidget {
  const _DarkField({
    required this.hint,
    required this.controller,
    this.maxLines = 1,
  });

  final String hint;
  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.md),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
        cursorColor: AppColors.accentGold,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              AppTextStyles.body1.copyWith(color: AppColors.textTertiary),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

// ─── Selector Row ────────────────────────────────────────────────────────────

class _SelectorRow extends StatelessWidget {
  const _SelectorRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.md + 2),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Text(
              label,
              style:
                  AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
            ),
            const Spacer(),
            Text(
              value,
              style: AppTextStyles.body2
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Mic Button ──────────────────────────────────────────────────────────────

class _MicButton extends StatelessWidget {
  const _MicButton({required this.isRecording});
  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        border: Border.all(
          color: AppColors.accentGold,
          width: isRecording ? 3 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGold
                .withValues(alpha: isRecording ? 0.55 : 0.30),
            blurRadius: isRecording ? 32 : 20,
            spreadRadius: isRecording ? 4 : 0,
          ),
        ],
      ),
      child: Icon(
        Icons.mic_rounded,
        size: 34,
        color: isRecording
            ? AppColors.accentGold
            : AppColors.accentGold.withValues(alpha: 0.85),
      ),
    );
  }
}
