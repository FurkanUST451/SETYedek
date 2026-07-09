import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

/// FCM push bildirimlerini yönetir:
/// - İzin ister, cihaz token'ını alır ve users/{uid}.fcmToken alanına yazar
/// - Token yenilendiğinde Firestore'daki kaydı günceller
/// - Bildirime tıklanınca ilgili sohbet ekranına yönlendirir
class NotificationService extends GetxService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? _userId;

  @override
  void onInit() {
    super.onInit();
    _messaging.onTokenRefresh.listen((token) {
      if (_userId != null) _saveToken(token);
    });
    // Uygulama arka plandayken bildirime tıklanırsa
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    // Uygulama kapalıyken bildirime tıklanarak açıldıysa
    _messaging.getInitialMessage().then((msg) {
      if (msg != null) _handleNotificationTap(msg);
    });
  }

  /// Giriş / kayıt / oturum geri yükleme sonrası çağrılır.
  Future<void> registerDevice(String userId) async {
    _userId = userId;
    try {
      final settings = await _messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;

      final token = await _messaging.getToken();
      if (token != null) await _saveToken(token);
    } catch (e) {
      debugPrint('NotificationService.registerDevice error: $e');
    }
  }

  /// Çıkış yapılırken çağrılır — token'ı hem cihazdan hem Firestore'dan siler
  /// ki kullanıcı çıkış yaptıktan sonra bildirim almasın.
  Future<void> unregisterDevice() async {
    final userId = _userId;
    _userId = null;
    try {
      if (userId != null) {
        await _db.collection('users').doc(userId).update({
          'fcmToken': FieldValue.delete(),
        });
      }
      await _messaging.deleteToken();
    } catch (e) {
      debugPrint('NotificationService.unregisterDevice error: $e');
    }
  }

  Future<void> _saveToken(String token) async {
    final userId = _userId;
    if (userId == null) return;
    try {
      await _db.collection('users').doc(userId).set(
        {'fcmToken': token},
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('NotificationService._saveToken error: $e');
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    if (data['type'] != 'chat_message') return;
    final chatId = data['chatId'] as String?;
    if (chatId == null || chatId.isEmpty) return;

    Get.toNamed(AppRoutes.chatDetail, arguments: {
      'chatId': chatId,
      'otherUserName': data['otherUserName'] ?? 'Sohbet',
      'briefTitle': data['briefTitle'] ?? '',
      'returnRoute': data['returnRoute'] ?? AppRoutes.clientHome,
    });
  }
}
