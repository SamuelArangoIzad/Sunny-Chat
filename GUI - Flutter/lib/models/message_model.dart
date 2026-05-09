class MessageModel {

  final int id;

  final String title;

  final String body;

  final String senderEmail;

  final String receiverEmail;

  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.title,
    required this.body,
    required this.senderEmail,
    required this.receiverEmail,
    required this.createdAt,
  });

  factory MessageModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return MessageModel(

      id: json['id'],

      title: json['title'],

      body: json['body'],

      senderEmail: json['sender_email'],

      receiverEmail: json['receiver_email'],

      createdAt: DateTime.parse(
        json['created_at'],
      ),
    );
  }
}