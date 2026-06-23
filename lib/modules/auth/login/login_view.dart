import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/set_text_field.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.surfaceDark,
                    AppColors.backgroundDark,
                  ],
                ),
              ),
            ),
            SafeArea(
              bottom: false,
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
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      'WELCOME BACK',
                      style: AppTextStyles.eyebrow.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Tekrar hoş geldin',
                      style: AppTextStyles.displayXL.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Hesabına giriş yap, üretmeye devam et.',
                      style: AppTextStyles.body1.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Theme(
                      data: Theme.of(context).copyWith(
                        brightness: Brightness.light,
                      ),
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
                                      color: AppColors.textSecondaryLight,
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
                            Obx(() => SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: Material(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(
                                        AppRadius.full),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(
                                          AppRadius.full),
                                      onTap: controller.isLoading.value
                                          ? null
                                          : controller.submit,
                                      child: Center(
                                        child: controller.isLoading.value
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.4,
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                          Colors.white),
                                                ),
                                              )
                                            : Text(
                                                AppStrings.login,
                                                style: AppTextStyles.button
                                                    .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
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
                            color: Colors.white70,
                          ),
                        ),
                        TextButton(
                          onPressed: controller.goToRegister,
                          child: Text(
                            AppStrings.register,
                            style: AppTextStyles.button.copyWith(
                              color: Colors.white,
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
      ),
    );
  }
}
