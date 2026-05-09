// lib/screens/received_messages_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/message_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ReceivedMessagesScreen extends StatefulWidget {
  const ReceivedMessagesScreen({super.key});

  @override
  State<ReceivedMessagesScreen> createState() =>
      _ReceivedMessagesScreenState();
}

class _ReceivedMessagesScreenState
    extends State<ReceivedMessagesScreen> {
  List<MessageModel> messages = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    getMessages();
  }

  Future<void> getMessages() async {
    try {
      final token = await StorageService.getToken();

      final response = await http.get(
        Uri.parse(
          '${ApiService.baseUrl}/messages/received',
        ),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body) as List;

      setState(() {
        messages = data
            .map((e) => MessageModel.fromJson(e))
            .toList();

        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes recibidos'),
      ),
      body: loading
          ? const Center(

    child: SizedBox(

      height: 26,
      width: 26,

      child: CircularProgressIndicator(

        strokeWidth: 2.5,

        color: Color(0xFF0F172A),
      ),
    ),
  )
          : messages.isEmpty
              ? const Center(
                  child: Text(
                    'No hay mensajes',
                  ),
                )
              : ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (_, index) {
                    final message = messages[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text(message.title),
                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text(message.body),
                            const SizedBox(height: 10),
                            Text(
                              'De: ${message.senderEmail}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}