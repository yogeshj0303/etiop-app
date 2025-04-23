import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission for notifications
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Print token for debugging
    final token = await getToken();
    print('FCM Token: $token');
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}
