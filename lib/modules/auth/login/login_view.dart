import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/set_button.dart';
import '../../../widgets/set_card.dart';
import '../../../widgets/set_text_field.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
          // Background image
          Positioned.fill(
            child: Image.asset(AppAssets.loginBg, fit: BoxFit.cover),
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
                    'WELCOME BACK',
                    style: AppTextStyles.eyebrow.copyWith(
                      color: AppColors.accentCyan,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Tekrar hoş geldin', style: AppTextStyles.displayXL),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Hesabına giriş yap, üretmeye devam et.',
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
                                hint: '••••••',
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
                                text: AppStrings.login,
                                onPressed: controller.submit,
                                isLoading: controller.isLoading.value,
                                size: SetButtonSize.hero,
                              )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.dontHaveAccount,
                        style: AppTextStyles.body2.copyWith(
                          color: secondaryColor,
                        ),
                      ),
                      TextButton(
                        onPressed: controller.goToRegister,
                        child: Text(
                          AppStrings.register,
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.primary,
                          ),
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
    );
  }
}
