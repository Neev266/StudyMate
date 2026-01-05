import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';


class CloudinaryService {
  static const String cloudName = "dlt95r1ky";
  static const String uploadPreset = "StudyMate";

  static Future<String?> uploadFile(File file) async {
  final isPdf = file.path.toLowerCase().endsWith('.pdf');

  final uri = Uri.parse(
    isPdf
        ? "https://api.cloudinary.com/v1_1/$cloudName/raw/upload"
        : "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
  );

  final request = http.MultipartRequest('POST', uri)
    ..fields['upload_preset'] = uploadPreset
    ..files.add(await http.MultipartFile.fromPath('file', file.path));

  final response = await request.send();
  final body = await response.stream.bytesToString();

  debugPrint("Cloudinary status: ${response.statusCode}");
  debugPrint("Cloudinary body: $body");

  if (response.statusCode == 200) {
    return jsonDecode(body)['secure_url'];
  }
  return null;
}



}



