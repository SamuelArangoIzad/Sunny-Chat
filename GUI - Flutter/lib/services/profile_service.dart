import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class ProfileService {

  static Future<String?> uploadPhoto({
    required File imageFile,
    required String email,
  }) async {

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        '${ApiService.baseUrl}/profile/upload-photo/$email',
      ),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ),
    );

    final response = await request.send();

    final responseBody =
        await response.stream.bytesToString();

    final data = jsonDecode(responseBody);

    return data['photo_url'];
  }
}