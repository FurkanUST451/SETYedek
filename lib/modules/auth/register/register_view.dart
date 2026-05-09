import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/set_button.dart';
import '../../../widgets/set_text_field.dart';
import 'register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hesap oluştur', style: AppTextStyles.heading1),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Birkaç saniyede SET\'e katıl.',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                SetTextField(
                  label: AppStrings.fullName,
                  hint: 'Ad Soyad',
                  controller: controller.nameController,
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.minLength(v, 2),
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
                        ),
                        onPressed: controller.toggleObscure,
                      ),
                      onSubmitted: (_) => controller.submit(),
                    )),
                const SizedBox(height: AppSpacing.lg),
                Obx(() {
                  final err = controller.errorMessage.value;
                  if (err == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Text(
                      err,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  );
                }),
                Obx(() => SetButton(
                      text: AppStrings.register,
                      onPressed: controller.submit,
                      isLoading: controller.isLoading.value,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
