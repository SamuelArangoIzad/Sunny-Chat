import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/user_model.dart';

import '../services/api_service.dart';
import '../services/profile_service.dart';
import '../services/storage_service.dart';

import 'chat_screen.dart';
import 'login_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() =>
      _UsersScreenState();
}

class _UsersScreenState
    extends State<UsersScreen> {

  List<UserModel> users = [];

  bool loading = true;

  String currentEmail = '';

  UserModel? currentUser;

  File? selectedImage;

  int imageVersion = 0;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {

    currentEmail =
        await StorageService.getEmail()
            ?? '';

    await getUsers();
  }

  Future<void> getUsers() async {

    final token =
        await StorageService.getToken();

    final response = await http.get(

      Uri.parse(
        '${ApiService.baseUrl}/users',
      ),

      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data =
        jsonDecode(response.body) as List;

    final loadedUsers = data
        .map(
          (e) => UserModel.fromJson(e),
        )
        .toList();

    UserModel? me;

    try {

      final myResponse =
          await http.get(

        Uri.parse(
          '${ApiService.baseUrl}/users/$currentEmail',
        ),

        headers: {
          'Authorization':
              'Bearer $token',
        },
      );

      me = UserModel.fromJson(
        jsonDecode(myResponse.body),
      );

    } catch (_) {}

    setState(() {

      users = loadedUsers;

      currentUser = me;

      loading = false;
    });
  }

  Future<void> pickImage() async {

    final picker = ImagePicker();

    final picked =
        await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked == null) return;

    final image = File(picked.path);

    setState(() {
      selectedImage = image;
    });

    final photoUrl =
        await ProfileService.uploadPhoto(

      imageFile: image,

      email: currentEmail,
    );

    if (photoUrl != null &&
        currentUser != null) {

      setState(() {

        imageVersion =
            DateTime.now()
                .millisecondsSinceEpoch;

        currentUser = UserModel(

          email:
              currentUser!.email,

          photoUrl: photoUrl,

          fullName:
              currentUser!.fullName,

          phone:
              currentUser!.phone,

          role:
              currentUser!.role,
        );
      });
    }

    await getUsers();
  }

Future<void> logout() async {

  await http.delete(

    Uri.parse(
      '${ApiService.baseUrl}/profile/logout/$currentEmail',
    ),
  );

  await StorageService.logout();

  if (!mounted) return;

  Navigator.pushAndRemoveUntil(

    context,

    MaterialPageRoute(
      builder: (_) =>
          const LoginScreen(),
    ),

    (route) => false,
  );
}

  Widget buildCurrentAvatar() {

    if (selectedImage != null) {

      return CircleAvatar(
        radius: 34,
        backgroundImage:
            FileImage(selectedImage!),
      );
    }

    if (currentUser?.photoUrl != null &&
        currentUser!.photoUrl!
            .isNotEmpty) {

      return CircleAvatar(

        radius: 34,

        backgroundImage:
            NetworkImage(

          '${currentUser!.photoUrl}?v=$imageVersion',
        ),
      );
    }

    return const CircleAvatar(

      radius: 34,

      backgroundColor:
          Color(0xFF1E293B),

      child: Icon(
        Icons.person,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  Widget buildUserAvatar(
    UserModel user,
  ) {

    if (user.photoUrl != null &&
        user.photoUrl!.isNotEmpty) {

      return CircleAvatar(

        radius: 28,

        backgroundImage:
            NetworkImage(
          '${user.photoUrl}?v=$imageVersion',
        ),
      );
    }

    return const CircleAvatar(

      radius: 28,

      backgroundColor:
          Color(0xFF1E293B),

      child: Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF1F5F9),

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

          : SafeArea(

              child: Column(

                children: [

                  Container(

                    width: double.infinity,

                    padding:
                        const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                      bottom: 22,
                    ),

                    decoration:
                        const BoxDecoration(

                      gradient:
                          LinearGradient(

                        colors: [

                          Color(0xFF020617),

                          Color(0xFF0F172A),
                        ],

                        begin:
                            Alignment.topLeft,

                        end:
                            Alignment.bottomRight,
                      ),

                      borderRadius:
                          BorderRadius.only(

                        bottomLeft:
                            Radius.circular(32),

                        bottomRight:
                            Radius.circular(32),
                      ),
                    ),

                    child: Row(

                      children: [

                        GestureDetector(

                          onTap: pickImage,

                          child:
                              buildCurrentAvatar(),
                        ),

                        const SizedBox(
                          width: 16,
                        ),

                        Expanded(

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(

                                currentUser
                                        ?.fullName ??
                                    '',

                                style:
                                    const TextStyle(

                                  color:
                                      Colors.white,

                                  fontSize: 20,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(

                                currentEmail,

                                style:
                                    TextStyle(

                                  color: Colors
                                      .white70,

                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(

                          decoration:
                              BoxDecoration(

                            color: Colors
                                .white
                                .withOpacity(
                                  0.08,
                                ),

                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                          ),

                          child: IconButton(

                            onPressed: logout,

                            icon: const Icon(
                              Icons.logout_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(

                    padding:
                        const EdgeInsets.all(16),

                    child: Container(

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),

                      decoration:
                          BoxDecoration(

                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),

                        boxShadow: [

                          BoxShadow(

                            color: Colors.black
                                .withOpacity(
                              0.03,
                            ),

                            blurRadius: 12,

                            offset:
                                const Offset(
                              0,
                              4,
                            ),
                          ),
                        ],
                      ),

                      child: const TextField(

                        decoration:
                            InputDecoration(

                          icon: Icon(
                            Icons.search_rounded,
                          ),

                          hintText:
                              'Buscar usuarios...',

                          border:
                              InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  Expanded(

                    child: ListView.builder(

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),

                      itemCount:
                          users.length,

                      itemBuilder:
                          (_, index) {

                        final user =
                            users[index];

                        return Container(

                          margin:
                              const EdgeInsets.only(
                            bottom: 14,
                          ),

                          decoration:
                              BoxDecoration(

                            color:
                                Colors.white,

                            borderRadius:
                                BorderRadius.circular(
                              24,
                            ),

                            boxShadow: [

                              BoxShadow(

                                color: Colors.black
                                    .withOpacity(
                                  0.04,
                                ),

                                blurRadius: 10,

                                offset:
                                    const Offset(
                                  0,
                                  3,
                                ),
                              ),
                            ],
                          ),

                          child: ListTile(

                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),

                            leading:
                                buildUserAvatar(
                              user,
                            ),

                            title: Text(

                              user.fullName,

                              style:
                                  const TextStyle(

                                color:
                                    Color(
                                  0xFF0F172A,
                                ),

                                fontWeight:
                                    FontWeight.bold,

                                fontSize: 16,
                              ),
                            ),

                            subtitle: Padding(

                              padding:
                                  const EdgeInsets.only(
                                top: 4,
                              ),

                              child: Text(

                                user.email,

                                style:
                                    const TextStyle(

                                  color:
                                      Color(
                                    0xFF64748B,
                                  ),

                                  fontSize: 13,
                                ),
                              ),
                            ),

                            trailing: Container(

                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),

                              decoration:
                                  BoxDecoration(

                                color:
                                    const Color(
                                  0xFF0F172A,
                                ),

                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),
                              ),

                              child: Text(

                                user.role,

                                style:
                                    const TextStyle(

                                  color:
                                      Colors.white70,

                                  fontWeight:
                                      FontWeight.w600,

                                  fontSize: 12,
                                ),
                              ),
                            ),

                            onTap: () {

                              Navigator.push(

                                context,

                                MaterialPageRoute(

                                  builder: (_) =>
                                      ChatScreen(
                                    user: user,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  Container(

                    margin:
                        const EdgeInsets.all(16),

                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),

                    decoration:
                        BoxDecoration(

                      gradient:
                          const LinearGradient(

                        colors: [

                          Color(0xFF020617),

                          Color(0xFF0F172A),
                        ],
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        22,
                      ),

                      boxShadow: [

                        BoxShadow(

                          color: Colors.black
                              .withOpacity(
                            0.08,
                          ),

                          blurRadius: 10,

                          offset:
                              const Offset(
                            0,
                            4,
                          ),
                        ),
                      ],
                    ),

                    child: Row(

                      children: [

                        const Icon(

                          Icons.notifications_active,

                          color: Colors.white,
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Expanded(

                          child: Text(

                            'Firebase Cloud Messaging activo en tiempo real',

                            style:
                                TextStyle(

                              color:
                                  Colors.white
                                      .withOpacity(
                                0.95,
                              ),

                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}