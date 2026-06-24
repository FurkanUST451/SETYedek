import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/freelancer_model.dart';
import '../../../data/repositories/freelancer_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../modules/app/user_controller.dart';
import '../../../routes/app_routes.dart';

class FreelancerOnboardingController extends GetxController {
  final FreelancerRepository _freelancerRepo = Get.find<FreelancerRepository>();
  final UserRepository _userRepo = Get.find<UserRepository>();

  final PageController pageController = PageController();
  final RxInt currentStep = 0.obs;
  final RxBool isLoading = false.obs;

  static const totalSteps = 4;

  static const List<String> turkishCities = [
    'Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Aksaray', 'Amasya',
    'Ankara', 'Antalya', 'Ardahan', 'Artvin', 'Aydın', 'Balıkesir',
    'Bartın', 'Batman', 'Bayburt', 'Bilecik', 'Bingöl', 'Bitlis',
    'Bolu', 'Burdur', 'Bursa', 'Çanakkale', 'Çankırı', 'Çorum',
    'Denizli', 'Diyarbakır', 'Düzce', 'Edirne', 'Elazığ', 'Erzincan',
    'Erzurum', 'Eskişehir', 'Gaziantep', 'Giresun', 'Gümüşhane',
    'Hakkari', 'Hatay', 'Iğdır', 'Isparta', 'İstanbul', 'İzmir',
    'Kahramanmaraş', 'Karabük', 'Karaman', 'Kars', 'Kastamonu',
    'Kayseri', 'Kırıkkale', 'Kırklareli', 'Kırşehir', 'Kilis',
    'Kocaeli', 'Konya', 'Kütahya', 'Malatya', 'Manisa', 'Mardin',
    'Mersin', 'Muğla', 'Muş', 'Nevşehir', 'Niğde', 'Ordu',
    'Osmaniye', 'Rize', 'Sakarya', 'Samsun', 'Siirt', 'Sinop',
    'Sivas', 'Şanlıurfa', 'Şırnak', 'Tekirdağ', 'Tokat', 'Trabzon',
    'Tunceli', 'Uşak', 'Van', 'Yalova', 'Yozgat', 'Zonguldak',
  ];

  // Step 0 — Personal Info
  final TextEditingController fullNameController = TextEditingController();
  final RxnString selectedCity = RxnString();
  final Rxn<DateTime> birthDate = Rxn<DateTime>();
  final RxInt selectedExperience = 0.obs;

  // Step 1 — Category (multi-select)
  final RxList<String> selectedCategories = <String>[].obs;

  // Step 2 — Bio
  final TextEditingController bioController = TextEditingController();

  // Step 3 — Portfolio (birden fazla proje)
  final RxList<PortfolioProject> addedProjects = <PortfolioProject>[].obs;

  List<String> get categories => DummyData.categories;
  bool get isLastStep => currentStep.value == totalSteps - 1;

  @override
  void onInit() {
    super.onInit();
    try {
      final user = Get.find<UserController>().currentUser;
      if (user != null) fullNameController.text = user.fullName;
    } catch (_) {}
  }

  void onPageChanged(int i) => currentStep.value = i;

  void toggleCategory(String cat) {
    if (selectedCategories.contains(cat)) {
      selectedCategories.remove(cat);
    } else {
      selectedCategories.add(cat);
    }
  }

  void setBirthDate(DateTime date) => birthDate.value = date;

  String get formattedBirthDate {
    final d = birthDate.value;
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  }

  void addProject(PortfolioProject project) => addedProjects.add(project);
  void removeProject(int index) => addedProjects.removeAt(index);

  void next() {
    if (isLastStep) {
      finish();
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  void previous() {
    if (currentStep.value == 0) return;
    pageController.previousPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  Future<void> finish() async {
    final user = Get.find<UserController>().currentUser;
    if (user == null) {
      Get.offAllNamed(AppRoutes.freelancerHome);
      return;
    }

    isLoading.value = true;
    try {
      // İsim-soyisim Firestore'daki kullanıcı kaydına yansıt
      final fullName = fullNameController.text.trim();
      if (fullName.isNotEmpty) {
        final parts = fullName.split(' ');
        final firstName = parts.first;
        final surname = parts.length > 1 ? parts.sublist(1).join(' ') : null;
        final updatedUser = user.copyWith(name: firstName, surname: surname);
        await _userRepo.upsertUser(updatedUser);
        Get.find<UserController>().setUser(updatedUser);
      }

      final freelancer = FreelancerModel(
        userId: user.id,
        categories: List<String>.from(selectedCategories),
        bio: bioController.text.trim(),
        experience: selectedExperience.value,
        location: selectedCity.value ?? '',
        rating: 0,
        birthDate: birthDate.value,
        projects: List<PortfolioProject>.from(addedProjects),
      );

      await _freelancerRepo.upsertFreelancer(freelancer);
      Get.offAllNamed(AppRoutes.freelancerHome);
    } catch (e) {
      debugPrint('FreelancerOnboarding finish() error: $e');
      Get.snackbar(
        'Hata',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 8),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    fullNameController.dispose();
    bioController.dispose();
    super.onClose();
  }
}
