import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  bool get isDark => theme.brightness == Brightness.dark;

  MediaQueryData get mq => MediaQuery.of(this);
  Size get screenSize => mq.size;
  double get screenWidth => mq.size.width;
  double get screenHeight => mq.size.height;
  EdgeInsets get safePadding => mq.padding;

  void hideKeyboard() => FocusScope.of(this).unfocus();
}
