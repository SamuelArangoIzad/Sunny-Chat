// lib/screens/conversation_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/message_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ConversationScreen extends StatefulWidget {
  final String email;

  const ConversationScreen({
    super.key,
    required this.email,
  });

  @override
  State<ConversationScreen> createState() =>
      _ConversationScreenState();
}

class _ConversationScreenState
    extends State<ConversationScreen> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  List<MessageModel> messages = [];

  @override
  void initState() {
    super.initState();

    getConversation();
  }

  Future<void> getConversation() async {
    final token = await StorageService.getToken();

    final response = await http.get(
      Uri.parse(
        '${ApiService.baseUrl}/messages/conversation/${widget.email}',
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
    });
  }

  Future<void> sendMessage() async {
    final token = await StorageService.getToken();

    await http.post(
      Uri.parse('${ApiService.baseUrl}/messages'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'receiver_email': widget.email,
        'title': titleController.text,
        'body': bodyController.text,
      }),
    );

    titleController.clear();
    bodyController.clear();

    await getConversation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.email),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final message = messages[index];

                return Card(
                  child: ListTile(
                    title: Text(message.title),
                    subtitle: Text(message.body),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Título',
                  ),
                ),
                TextField(
                  controller: bodyController,
                  decoration: const InputDecoration(
                    hintText: 'Mensaje',
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: sendMessage,
                    child: const Text('Enviar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}