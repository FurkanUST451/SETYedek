import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class SendOfferController extends GetxController {
  // Category passed from previous screen
  late final String category;

  final RxString selectedShootingType = ''.obs;
  final RxList<String> selectedVibes = <String>[].obs;
  final RxString selectedDateRange = ''.obs;
  final RxString selectedDelivery = ''.obs;
  final RxString selectedBudget = ''.obs;
  final RxString selectedLocation = ''.obs;
  final RxBool isSubmitting = false.obs;

  static const shootingTypes = [
    'Reklam Filmi Yatay',
    'Reklam Filmi Dikey',
    'Marka Filmi',
    'Kurumsal Video',
    'Tanıtım Filmi',
    'Sosyal Medya İçeriği',
  ];

  static const vibeOptions = [
    'Enerjik',
    'Cinematic',
    'Luxury',
    'Minimalist',
    'Duygusal',
    'Komik',
  ];

  static const dateRangeOptions = [
    '12 - 16 Haziran',
    '17 - 21 Haziran',
    '22 - 26 Haziran',
    '1 - 5 Temmuz',
    '6 - 10 Temmuz',
    'Tarih Belirsiz',
  ];

  static const deliveryOptions = [
    '3 Gün',
    '7 Gün',
    '14 Gün',
    '1 Ay',
    '2+ Ay',
  ];

  static const budgetOptions = [
    '10.000₺ - 30.000₺',
    '30.000₺ - 50.000₺',
    '50.000₺ - 120.000₺',
    '120.000₺ - 300.000₺',
    '300.000₺+',
  ];

  static const locationOptions = [
    'İstanbul / Beşiktaş',
    'İstanbul / Kadıköy',
    'İstanbul / Şişli',
    'Ankara / Çankaya',
    'İzmir / Alsancak',
    'Uzaktan',
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    category = (args?['category'] as String?) ?? '';
    // Defaults
    selectedShootingType.value = 'Reklam Filmi Yatay';
    selectedVibes.assignAll(['Enerjik']);
    selectedDateRange.value = '12 - 16 Haziran';
    selectedDelivery.value = '7 Gün';
    selectedBudget.value = '50.000₺ - 120.000₺';
    selectedLocation.value = 'İstanbul / Beşiktaş';
  }

  void toggleVibe(String vibe) {
    if (selectedVibes.contains(vibe)) {
      if (selectedVibes.length > 1) selectedVibes.remove(vibe);
    } else {
      selectedVibes.add(vibe);
    }
  }

  Future<void> submit() async {
    isSubmitting.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    isSubmitting.value = false;
    Get.toNamed(
      AppRoutes.briefShare,
      arguments: {
        'category': category,
        'shootingType': selectedShootingType.value,
        'vibes': selectedVibes.toList(),
        'dateRange': selectedDateRange.value,
        'deliveryTime': selectedDelivery.value,
        'budget': selectedBudget.value,
        'location': selectedLocation.value,
      },
    );
  }
}
