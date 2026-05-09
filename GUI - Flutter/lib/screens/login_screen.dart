import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/push_service.dart';
import '../services/storage_service.dart';

import 'register_screen.dart';
import 'users_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool loading = false;

  Future<void> login() async {

    setState(() {
      loading = true;
    });

    try {

      final fcmToken =
          await PushService().init();

      final response =
          await AuthService.login(

        email:
            emailController.text.trim(),

        password:
            passwordController.text.trim(),

        token: fcmToken ?? '',
      );

      await StorageService.saveToken(
        response['access_token'],
      );

      await StorageService.saveEmail(
        emailController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(
          builder: (_) =>
              const UsersScreen(),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF1F5F9),

      body: Stack(

        children: [

          Container(

            height: 320,

            decoration:
                const BoxDecoration(

              gradient: LinearGradient(

                begin:
                    Alignment.topLeft,

                end:
                    Alignment.bottomRight,

                colors: [

                  Color(0xFF020617),
                  Color(0xFF0F172A),
                  Color(0xFF1E293B),
                ],
              ),
            ),
          ),

          Center(

            child: SingleChildScrollView(

              padding:
                  const EdgeInsets.all(24),

              child: Container(

                padding:
                    const EdgeInsets.all(28),

                decoration:
                    BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    32,
                  ),

                  boxShadow: [

                    BoxShadow(

                      color: Colors.black
                          .withOpacity(
                        0.08,
                      ),

                      blurRadius: 20,

                      offset:
                          const Offset(
                        0,
                        8,
                      ),
                    ),
                  ],
                ),

                child: Column(

                  mainAxisSize:
                      MainAxisSize.min,

                  children: [

                    Container(

                      width: 90,
                      height: 90,

                      decoration:
                          BoxDecoration(

                        color:
                            const Color(
                          0xFF0F172A,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          28,
                        ),
                      ),

                      child: const Icon(

                        Icons.chat_rounded,

                        color:
                            Colors.white,

                        size: 42,
                      ),
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    const Text(

                      'Bienvenido',

                      style: TextStyle(

                        fontSize: 28,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(

                      'Inicia sesión para continuar',

                      style: TextStyle(

                        color:
                            Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(
                      height: 32,
                    ),

                    TextField(

                      controller:
                          emailController,

                      decoration:
                          InputDecoration(

                        hintText:
                            'Correo',

                        prefixIcon:
                            const Icon(
                          Icons.email,
                        ),

                        filled: true,

                        fillColor:
                            const Color(
                          0xFFF8FAFC,
                        ),

                        border:
                            OutlineInputBorder(

                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),

                          borderSide:
                              BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    TextField(

                      controller:
                          passwordController,

                      obscureText: true,

                      decoration:
                          InputDecoration(

                        hintText:
                            'Contraseña',

                        prefixIcon:
                            const Icon(
                          Icons.lock,
                        ),

                        filled: true,

                        fillColor:
                            const Color(
                          0xFFF8FAFC,
                        ),

                        border:
                            OutlineInputBorder(

                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),

                          borderSide:
                              BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 28,
                    ),

                    SizedBox(

                      width:
                          double.infinity,

                      height: 58,

                      child: ElevatedButton(

                        onPressed:
                            loading
                                ? null
                                : login,

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

                                    'Ingresar',

                                    style:
                                        TextStyle(

                                      color:
                                          Colors.white,

                                      fontSize: 16,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    TextButton(

                      onPressed: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                const RegisterScreen(),
                          ),
                        );
                      },

                      child: const Text(
                        'Crear cuenta',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}