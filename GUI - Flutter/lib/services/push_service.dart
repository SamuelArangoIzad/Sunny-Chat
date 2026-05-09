import 'package:firebase_messaging/firebase_messaging.dart';

class PushService {
  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  Future<String?> init() async {
    await _messaging.requestPermission();

    final token = await _messaging.getToken();

    print('FCM TOKEN => $token');

    return token;
  }
}