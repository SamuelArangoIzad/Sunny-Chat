import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String token,
  }) async {
    final url = Uri.parse(
      '${ApiService.baseUrl}/auth/login',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'fcm_token': token,
      }),
    );

    print('LOGIN STATUS => ${response.statusCode}');
    print('LOGIN BODY => ${response.body}');

    final data = jsonDecode(response.body);

    return Map<String, dynamic>.from(data);
  }

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
    required String token,
  }) async {
    final url = Uri.parse(
      '${ApiService.baseUrl}/auth/register',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'photo_url': '',
        'full_name': fullName,
        'phone': phone,
        'role': role,
        'fcm_token': token,
      }),
    );

    print('REGISTER STATUS => ${response.statusCode}');
    print('REGISTER BODY => ${response.body}');

    final data = jsonDecode(response.body);

    return Map<String, dynamic>.from(data);
  }
}