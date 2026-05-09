import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/message_model.dart';
import '../models/user_model.dart';

import '../services/message_service.dart';
import '../services/storage_service.dart';

class ChatScreen extends StatefulWidget {

  final UserModel user;

  const ChatScreen({
    super.key,
    required this.user,
  });

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends State<ChatScreen> {

  List<MessageModel> messages = [];

  final controller =
      TextEditingController();

  final scrollController =
      ScrollController();

  String? myEmail;

  Timer? refreshTimer;

  bool loading = true;

  @override
  void initState() {

    super.initState();

    initialize();
  }

  Future<void> initialize() async {

    await loadCurrentUser();

    await getMessages();

    refreshTimer = Timer.periodic(

      const Duration(seconds: 2),

      (_) async {

        await getMessages();
      },
    );
  }

  @override
  void dispose() {

    refreshTimer?.cancel();

    controller.dispose();

    scrollController.dispose();

    super.dispose();
  }

  Future<void> loadCurrentUser() async {

    final token =
        await StorageService.getToken();

    if (token == null) return;

    final payload =
        token.split('.')[1];

    final normalized =
        base64Url.normalize(payload);

    final response = utf8.decode(

      base64Url.decode(normalized),
    );

    final data =
        jsonDecode(response);

    myEmail = data['sub'];
  }

  Future<void> getMessages() async {

    try {

      final data =
          await MessageService.getConversation(
        widget.user.email,
      );

      if (!mounted) return;

      final oldLength =
          messages.length;

      setState(() {

        messages = data;

        loading = false;
      });

      if (messages.length != oldLength) {

        Future.delayed(

          const Duration(
            milliseconds: 100,
          ),

          scrollToBottom,
        );
      }

    } catch (e) {

      debugPrint(
        e.toString(),
      );
    }
  }

  void scrollToBottom() {

    if (!scrollController.hasClients) {
      return;
    }

    scrollController.animateTo(

      scrollController.position
          .maxScrollExtent,

      duration:
          const Duration(
        milliseconds: 300,
      ),

      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessage() async {

    if (controller.text
        .trim()
        .isEmpty) {
      return;
    }

    final text =
        controller.text.trim();

    controller.clear();

    await MessageService.sendMessage(

      receiverEmail:
          widget.user.email,

      title: 'Chat',

      body: text,
    );

    await getMessages();
  }

  String formatTime(
    DateTime date,
  ) {

    final hour =
        date.hour
            .toString()
            .padLeft(2, '0');

    final minute =
        date.minute
            .toString()
            .padLeft(2, '0');

    return '$hour:$minute';
  }

  Widget buildAvatar() {

    if (widget.user.photoUrl != null &&
        widget.user.photoUrl!
            .isNotEmpty) {

      return ClipRRect(

        borderRadius:
            BorderRadius.circular(14),

        child: Image.network(

          widget.user.photoUrl!,

          width: 46,
          height: 46,

          fit: BoxFit.cover,

          errorBuilder:
              (_, __, ___) {

            return Container(

              width: 46,
              height: 46,

              decoration:
                  BoxDecoration(

                color:
                    const Color(
                  0xFF1E293B,
                ),

                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),

              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            );
          },
        ),
      );
    }

    return Container(

      width: 46,
      height: 46,

      decoration: BoxDecoration(

        color:
            const Color(
          0xFF1E293B,
        ),

        borderRadius:
            BorderRadius.circular(14),
      ),

      child: const Icon(
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

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
            const Color(0xFF020617),

        titleSpacing: 0,

        title: Row(

          children: [

            buildAvatar(),

            const SizedBox(width: 12),

            Expanded(

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Text(

                    widget.user.fullName,

                    style:
                        const TextStyle(

                      fontSize: 16,

                      fontWeight:
                          FontWeight.w600,

                      color:
                          Colors.white,
                    ),
                  ),

                  const SizedBox(
                    height: 2,
                  ),

                  Text(

                    widget.user.email,

                    style:
                        const TextStyle(

                      fontSize: 12,

                      color:
                          Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: loading

          ? const Center(

              child: SizedBox(

                width: 26,
                height: 26,

                child:
                    CircularProgressIndicator(
                  strokeWidth: 2.5,
                ),
              ),
            )

          : Column(

              children: [

                Expanded(

                  child: ListView.builder(

                    controller:
                        scrollController,

                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    itemCount:
                        messages.length,

                    itemBuilder:
                        (_, index) {

                      final msg =
                          messages[index];

                      final isMe =

                          msg.senderEmail ==
                              myEmail;

                      return Align(

                        alignment: isMe

                            ? Alignment
                                .centerRight

                            : Alignment
                                .centerLeft,

                        child: Container(

                          margin:
                              const EdgeInsets.only(
                            bottom: 12,
                          ),

                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),

                          constraints:
                              const BoxConstraints(
                            maxWidth: 300,
                          ),

                          decoration:
                              BoxDecoration(

                            color: isMe

                                ? const Color(
                                    0xFF0F172A,
                                  )

                                : Colors.white,

                            borderRadius:
                                BorderRadius.only(

                              topLeft:
                                  const Radius.circular(
                                20,
                              ),

                              topRight:
                                  const Radius.circular(
                                20,
                              ),

                              bottomLeft:
                                  Radius.circular(
                                isMe
                                    ? 20
                                    : 4,
                              ),

                              bottomRight:
                                  Radius.circular(
                                isMe
                                    ? 4
                                    : 20,
                              ),
                            ),

                            boxShadow: [

                              BoxShadow(

                                color: Colors
                                    .black
                                    .withOpacity(
                                  0.04,
                                ),

                                blurRadius: 8,

                                offset:
                                    const Offset(
                                  0,
                                  3,
                                ),
                              ),
                            ],
                          ),

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(

                                msg.body,

                                style:
                                    TextStyle(

                                  color: isMe

                                      ? Colors
                                          .white

                                      : Colors
                                          .black87,

                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(
                                height: 6,
                              ),

                              Align(

                                alignment:
                                    Alignment
                                        .bottomRight,

                                child: Text(

                                  formatTime(
                                    msg.createdAt,
                                  ),

                                  style:
                                      TextStyle(

                                    fontSize: 11,

                                    color: isMe

                                        ? Colors
                                            .white70

                                        : Colors
                                            .grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SafeArea(

                  child: Container(

                    padding:
                        const EdgeInsets.fromLTRB(
                      14,
                      10,
                      14,
                      10,
                    ),

                    decoration:
                        const BoxDecoration(
                      color: Colors.white,
                    ),

                    child: Row(

                      children: [

                        Expanded(

                          child: TextField(

                            controller:
                                controller,

                            decoration:
                                InputDecoration(

                              hintText:
                                  'Escribe un mensaje',

                              filled: true,

                              fillColor:
                                  const Color(
                                0xFFF1F5F9,
                              ),

                              contentPadding:
                                  const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
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
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Container(

                          width: 52,
                          height: 52,

                          decoration:
                              const BoxDecoration(

                            color:
                                Color(
                              0xFF0F172A,
                            ),

                            shape:
                                BoxShape.circle,
                          ),

                          child: IconButton(

                            onPressed:
                                sendMessage,

                            icon: const Icon(

                              Icons.send_rounded,

                              color:
                                  Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}