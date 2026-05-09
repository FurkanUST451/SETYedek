import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../app/auth_controller.dart';

class LoginController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool obscurePassword = true.obs;

  RxBool get isLoading => _auth.isLoading;
  RxnString get errorMessage => _auth.errorMessage;

  void toggleObscure() => obscurePassword.toggle();

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final ok = await _auth.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    if (ok) Get.offAllNamed(AppRoutes.roleSelection);
  }

  void goToRegister() => Get.toNamed(AppRoutes.register);

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
