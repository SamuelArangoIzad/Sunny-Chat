import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/message_model.dart';

import 'api_service.dart';
import 'storage_service.dart';

class MessageService {

  static Future<List<MessageModel>>
      getConversation(
    String email,
  ) async {

    final token =
        await StorageService.getToken();

    final response = await http.get(

      Uri.parse(
        '${ApiService.baseUrl}/messages/conversation/$email',
      ),

      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data =
        jsonDecode(response.body) as List;

    return data
        .map(
          (e) => MessageModel.fromJson(e),
        )
        .toList();
  }

  static Future<void> sendMessage({

    required String receiverEmail,

    required String title,

    required String body,

  }) async {

    final token =
        await StorageService.getToken();

    await http.post(

      Uri.parse(
        '${ApiService.baseUrl}/messages',
      ),

      headers: {

        'Content-Type': 'application/json',

        'Authorization': 'Bearer $token',
      },

      body: jsonEncode({

        'receiver_email': receiverEmail,

        'title': title,

        'body': body,
      }),
    );
  }
}