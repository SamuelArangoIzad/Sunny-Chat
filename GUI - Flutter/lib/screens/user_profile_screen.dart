import 'package:flutter/material.dart';

import '../models/user_model.dart';
import 'conversation_screen.dart';

class UserProfileScreen extends StatelessWidget {
  final UserModel user;

  const UserProfileScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage:
                  user.photoUrl != null &&
                          user.photoUrl!.isNotEmpty
                      ? NetworkImage(user.photoUrl!)
                      : null,
              child:
                  user.photoUrl == null ||
                          user.photoUrl!.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 60,
                        )
                      : null,
            ),

            const SizedBox(height: 20),

            Text(
              user.fullName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              user.email,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            Text(
              'Teléfono: ${user.phone}',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            Text(
              'Cargo: ${user.role}',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConversationScreen(
                        email: user.email,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.message),
                label: const Text(
                  'Enviar mensaje',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}