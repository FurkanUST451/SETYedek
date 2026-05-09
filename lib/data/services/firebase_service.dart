/// Firebase entry point — şimdilik sadece bağlantı kurulacak şekilde hazırdır.
///
/// Implementasyon için:
/// 1. `flutterfire configure` ile `firebase_options.dart` üretin.
/// 2. main.dart'ta [FirebaseService.initialize] çağrısını aktif edin.
///
/// `firebase_auth`, `cloud_firestore`, `firebase_storage` paketleri
/// `pubspec.yaml`'a eklendi. Servis sınıfları implementasyon aşamasında
/// instance'ları wrap edecek.
class FirebaseService {
  FirebaseService._();

  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  static Future<void> initialize() async {
    if (_initialized) return;
    // TODO: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    _initialized = true;
  }
}
