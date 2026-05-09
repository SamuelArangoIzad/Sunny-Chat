import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/push_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final fullNameController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  bool loading = false;

  Future<void> register() async {

    setState(() {
      loading = true;
    });

    try {

      final token =
          await PushService().init();

      await AuthService.register(

        email:
            emailController.text.trim(),

        password:
            passwordController.text.trim(),

        fullName:
            fullNameController.text.trim(),

        phone:
            phoneController.text.trim(),

        role: 'student',

        token: token ?? '',
      );

      if (!mounted) return;

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:
              Text(e.toString()),
        ),
      );
    }

    setState(() {
      loading = false;
    });
  }

  InputDecoration inputStyle(
    String hint,
    IconData icon,
  ) {

    return InputDecoration(

      hintText: hint,

      prefixIcon: Icon(icon),

      filled: true,

      fillColor:
          const Color(0xFFF8FAFC),

      border: OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(18),

        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF1F5F9),

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
            const Color(0xFF0F172A),

        title: const Text(

          'Registro',

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(24),

        child: Column(

          children: [

            const SizedBox(height: 20),

            TextField(
              controller:
                  fullNameController,
              decoration: inputStyle(
                'Nombre completo',
                Icons.person,
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller:
                  emailController,
              decoration: inputStyle(
                'Correo',
                Icons.email,
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller:
                  phoneController,
              decoration: inputStyle(
                'Teléfono',
                Icons.phone,
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller:
                  passwordController,
              obscureText: true,
              decoration: inputStyle(
                'Contraseña',
                Icons.lock,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              height: 58,

              child: ElevatedButton(

                onPressed:
                    loading
                        ? null
                        : register,

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      const Color(
                    0xFF0F172A,
                  ),

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                ),

                child:
                    loading

                        ? const SizedBox(

  height: 22,
  width: 22,

  child: CircularProgressIndicator(
    strokeWidth: 2.5,
    color: Colors.white,
  ),
)

                        : const Text(

                            'Registrarse',

                            style: TextStyle(

                              color:
                                  Colors.white,

                              fontSize: 16,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}