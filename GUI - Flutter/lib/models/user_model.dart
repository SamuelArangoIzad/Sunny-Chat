class UserModel {
  final String email;
  final String? photoUrl;
  final String fullName;
  final String phone;
  final String role;

  UserModel({
    required this.email,
    required this.photoUrl,
    required this.fullName,
    required this.phone,
    required this.role,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      email: json['email'] ?? '',
      photoUrl: json['photo_url'],
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
    );
  }
}