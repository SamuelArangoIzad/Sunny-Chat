import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class PushService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _messaging.requestPermission();

    String? token = await _messaging.getToken();

    print("FCM TOKEN: $token");

    if (token != null) {
      await sendTokenToBackend(token);
    }
  }

  Future<void> sendTokenToBackend(String token) async {
    final url = Uri.parse(
      'http://10.0.2.2:8000/auth/register',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": "test@test.com",
        "password": "123456",
        "full_name": "Samuel",
        "phone": "3000000000",
        "role": "student",
        "fcm_token": token
      }),
    );

    print(response.statusCode);
    print(response.body);
  }
}