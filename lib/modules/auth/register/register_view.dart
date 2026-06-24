import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/set_button.dart';
import '../../../widgets/set_card.dart';
import '../../../widgets/set_text_field.dart';
import 'register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Stack(
        children: [
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentCyan.withValues(alpha: isDark ? 0.2 : 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xxl,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.wordmark.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    'NEW HERE',
                    style: AppTextStyles.eyebrow.copyWith(
                      color: AppColors.accentCyan,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Hesap oluştur', style: AppTextStyles.displayXL),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    "Birkaç saniyede SET'e katıl.",
                    style: AppTextStyles.body1.copyWith(color: secondaryColor),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SetCard(
                    glow: true,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ad + Soyad yan yana
                          Row(
                            children: [
                              Expanded(
                                child: SetTextField(
                                  label: 'Ad',
                                  hint: 'Adın',
                                  controller: controller.nameController,
                                  textInputAction: TextInputAction.next,
                                  validator: (v) =>
                                      Validators.minLength(v, 2),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: SetTextField(
                                  label: 'Soyad',
                                  hint: 'Soyadın',
                                  controller: controller.surnameController,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Yaş + Cinsiyet yan yana
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 90,
                                child: SetTextField(
                                  label: 'Yaş',
                                  hint: '25',
                                  controller: controller.ageController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return null;
                                    final n = int.tryParse(v);
                                    if (n == null || n < 13 || n > 100) {
                                      return 'Geçersiz';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: _GenderSelector(
                                  selected: controller.selectedGender,
                                  onSelect: controller.setGender,
                                  isDark: isDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),

                          SetTextField(
                            label: AppStrings.email,
                            hint: 'ornek@set.app',
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: Validators.email,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Obx(() => SetTextField(
                                label: AppStrings.password,
                                hint: 'En az 6 karakter',
                                controller: controller.passwordController,
                                obscureText: controller.obscurePassword.value,
                                textInputAction: TextInputAction.done,
                                validator: Validators.password,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.obscurePassword.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: secondaryColor,
                                  ),
                                  onPressed: controller.toggleObscure,
                                ),
                                onSubmitted: (_) => controller.submit(),
                              )),
                          Obx(() {
                            final err = controller.errorMessage.value;
                            if (err == null) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(
                                top: AppSpacing.md,
                              ),
                              child: Text(
                                err,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: AppSpacing.lg),
                          Obx(() => SetButton(
                                text: AppStrings.register,
                                onPressed: controller.submit,
                                isLoading: controller.isLoading.value,
                                size: SetButtonSize.hero,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Cinsiyet seçici chip grubu
class _GenderSelector extends StatelessWidget {
  const _GenderSelector({
    required this.selected,
    required this.onSelect,
    required this.isDark,
  });

  final RxnString selected;
  final void Function(String) onSelect;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final labelColor =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CİNSİYET',
          style: AppTextStyles.eyebrow.copyWith(color: labelColor),
        ),
        const SizedBox(height: AppSpacing.sm),
        Obx(() => Row(
              children: [
                _Chip(
                  label: 'Erkek',
                  active: selected.value == 'erkek',
                  onTap: () => onSelect('erkek'),
                  isDark: isDark,
                ),
                const SizedBox(width: 6),
                _Chip(
                  label: 'Kadın',
                  active: selected.value == 'kadin',
                  onTap: () => onSelect('kadin'),
                  isDark: isDark,
                ),
                const SizedBox(width: 6),
                _Chip(
                  label: 'Diğer',
                  active: selected.value == 'diger',
                  onTap: () => onSelect('diger'),
                  isDark: isDark,
                ),
              ],
            )),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.active,
    required this.onTap,
    required this.isDark,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.15)
              : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight)
                  .withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? AppColors.primary : (isDark ? AppColors.border : AppColors.borderLight),
            width: active ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.primary : (isDark ? AppColors.textSecondary : AppColors.textSecondaryLight),
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
