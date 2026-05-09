import '../constants/app_strings.dart';

class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    return null;
  }

  static String? email(String? value) {
    final base = required(value);
    if (base != null) return base;
    if (!_emailRegex.hasMatch(value!.trim())) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  static String? password(String? value, {int minLength = 6}) {
    final base = required(value);
    if (base != null) return base;
    if (value!.length < minLength) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  static String? minLength(String? value, int min) {
    final base = required(value);
    if (base != null) return base;
    if (value!.trim().length < min) {
      return 'En az $min karakter olmalı';
    }
    return null;
  }
}
