# SET

Video prodüksiyon sektöründe freelancer ile müşterileri buluşturan marketplace mobil uygulaması. 3 ana kullanıcı rolü:
- **Client** — Freelancer arayan müşteri
- **Freelancer** — İş arayan profesyonel
- **ProjectClient** — "Projeni SET Yapsın" — tam servis prodüksiyon isteyen müşteri

---

## Teknoloji

| Katman | Seçim |
|---|---|
| State management & routing | [GetX](https://pub.dev/packages/get) |
| Backend | Firebase (Auth, Firestore, Storage) — bağlantı hazır, implementasyon sonra |
| HTTP | Dio |
| Local storage | GetStorage |
| Min SDK | Flutter 3.x · Dart 3.10+ |

## Klasör Yapısı

```
lib/
├── main.dart                       # Uygulama girişi, GetMaterialApp
├── core/
│   ├── theme/                      # AppColors, AppTextStyles, AppSpacing, AppRadius, AppTheme
│   ├── constants/                  # AppStrings, AppAssets
│   ├── utils/                      # Validators, Formatters
│   └── extensions/                 # Context, String extensions
├── data/
│   ├── models/                     # UserModel, FreelancerModel, ProjectModel, OfferModel, MessageModel
│   ├── repositories/               # AuthRepository, UserRepository, FreelancerRepository
│   ├── services/                   # FirebaseService, StorageService, DioService
│   └── dummy/                      # Mock data
├── modules/
│   ├── app/                        # Global controllers + InitialBinding
│   ├── splash/
│   ├── onboarding/
│   ├── auth/
│   │   ├── login/
│   │   └── register/
│   ├── role_selection/
│   ├── client/
│   │   ├── home/                   # tabs: discover, chat, profile
│   │   ├── freelancer_detail/
│   │   ├── send_offer/
│   │   └── chat_detail/
│   ├── freelancer/
│   │   ├── onboarding/             # 4 adımlı form
│   │   └── home/                   # tabs: discover, chat, projects, profile
│   └── project_client/
│       ├── onboarding/             # 4 adımlı brief
│       └── home/                   # tabs: discover, settings
├── routes/
│   ├── app_routes.dart             # Tüm route path'leri (string sabitler)
│   └── app_pages.dart              # GetPage tanımları + binding'ler
└── widgets/                        # SetButton, SetTextField, SetCard, SetAvatar, SetBottomNav
```

Her ekran modülü GetX patternine uyar: `<screen>_view.dart` + `<screen>_controller.dart` + `<screen>_binding.dart`.

## Kurulum

```bash
flutter pub get
flutter run
```

Geliştirme cihazı seçimi için: `flutter devices`

## Firebase Entegrasyonu (TODO)

Proje Firebase paketlerini içerir ancak henüz `firebase_options.dart` üretilmemiştir. Bağlamak için:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Sonra `lib/data/services/firebase_service.dart` içindeki TODO yorumunu aktif edin ve `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` çağrısını ekleyin.

Kontrolerlerdeki auth/db çağrıları şu an mock'tur (`Future.delayed`). Gerçek implementasyon için `lib/data/repositories/` altındaki sınıfları FirebaseAuth / Firestore çağrıları ile doldurun.

## Mimari Notlar

- **Routing** — Tüm path'ler `AppRoutes` sabitinde toplanır. Her sayfanın binding'i `AppPages.pages` içinde tanımlıdır; navigasyon `Get.toNamed(AppRoutes.x)` ile yapılır.
- **Route guard** — `SplashController` boot sırasında `GetStorage`'dan `userId` ve `userRole`'u okur, kullanıcıyı uygun ekrana atar (onboarding → login → role selection → role-specific home).
- **Global controllers** — `AuthController`, `UserController`, `ThemeController` `InitialBinding` ile `permanent: true` olarak `main()` başında ayağa kalkar.
- **Tema** — Dark default, light hazır. `ThemeController.toggle()` `GetStorage`'a yazar; sonraki açılışta korunur.
- **Tasarım sistemi** — `AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadius` sabit sınıflarıyla tutarlılık sağlanır. Shared widget'lar (`SetButton`, `SetTextField`, ...) bu sabitleri kullanır.
- **Modeller** — Tüm modeller `fromJson` / `toJson` / `copyWith` içerir. Firestore'a hazırdır; tarih alanları ISO8601 string olarak serialize edilir.

## Yol Haritası

- [ ] Firebase auth gerçek implementasyon
- [ ] Firestore ile freelancer, proje, mesaj koleksiyonları
- [ ] Firebase Storage ile portföy/avatar yükleme
- [ ] Push notification (FCM)
- [ ] Asset/font ekleme + `flutter_launcher_icons` ve `flutter_native_splash` config
