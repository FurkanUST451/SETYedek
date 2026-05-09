class AppAssets {
  AppAssets._();

  // Base paths (assets klasörü pubspec.yaml'a eklenince doldurulacak)
  static const String _images = 'assets/images';
  static const String _icons = 'assets/icons';

  // Placeholder örnekler — gerçek dosyalar eklendiğinde aktif edilecek
  static const String logo = '$_images/logo.png';
  static const String onboarding1 = '$_images/onboarding_1.png';
  static const String onboarding2 = '$_images/onboarding_2.png';
  static const String onboarding3 = '$_images/onboarding_3.png';

  static const String iconCamera = '$_icons/camera.svg';
  static const String iconMic = '$_icons/mic.svg';
}
