import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../app/auth_controller.dart';

class RegisterController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool obscurePassword = true.obs;

  RxBool get isLoading => _auth.isLoading;
  RxnString get errorMessage => _auth.errorMessage;

  void toggleObscure() => obscurePassword.toggle();

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final ok = await _auth.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    if (ok) Get.offAllNamed(AppRoutes.roleSelection);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
