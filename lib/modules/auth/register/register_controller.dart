import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../app/auth_controller.dart';

class RegisterController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool obscurePassword = true.obs;
  final RxnString selectedGender = RxnString();

  RxBool get isLoading => _auth.isLoading;
  RxnString get errorMessage => _auth.errorMessage;

  void toggleObscure() => obscurePassword.toggle();
  void setGender(String value) => selectedGender.value = value;

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final ageText = ageController.text.trim();
    final ok = await _auth.register(
      name: nameController.text.trim(),
      surname: surnameController.text.trim().isEmpty
          ? null
          : surnameController.text.trim(),
      age: ageText.isEmpty ? null : int.tryParse(ageText),
      gender: selectedGender.value,
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    if (ok) Get.offAllNamed(AppRoutes.roleSelection);
  }

  @override
  void onClose() {
    nameController.dispose();
    surnameController.dispose();
    ageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
