import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart' show ByteData;
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/user_model.dart';
import 'package:tukangku/utils/error_message.dart';
import 'package:path/path.dart';

class ProfileRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<ResponseModel?> updateProfile(String _token, User user) async {
    try {
      final response =
          await http.patch(Uri.parse(_baseUrl + '/auth/update-user'),
              headers: {
                'Authorization': 'Bearer $_token',
                'Content-Type': 'application/json',
                'Accept': 'application/json'
              },
              body: jsonEncode(<String, dynamic>{
                'name': user.name,
                'address': user.address,
                'date_of_birth': user.dateOfBirth,
                'number': user.number,
              }));

      print(response.body);

      // Error handling
      if (response.statusCode == 201) {
        var jsonResponse = json.decode(response.body);
        return ResponseModel.toJson(jsonResponse);
      } else {
        throw Exception(ErrorMessage.statusCode(response.statusCode));
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<ResponseModel?> updatePhoto(String _token, File file) async {
    try {
      // Initialize data
      http.MultipartRequest request = http.MultipartRequest(
          'POST', Uri.parse(_baseUrl + '/auth/change-image'));

      // Convert file type to byte data
      final byte = await file.readAsBytes();
      ByteData byteData = byte.buffer.asByteData();
      List<int> byteImage = byteData.buffer.asUint8List();

      // Set request value
      request.files.add(http.MultipartFile.fromBytes('images', byteImage,
          filename: basename(file.path)));
      request.headers['Authorization'] = "Bearer $_token";
      request.headers['Accept'] = "application/json";

      // Send request
      http.StreamedResponse streamedResponse = await request.send();
      final response =
          await http.Response.fromStream(streamedResponse); // get body response
      print(response.body);

      // Error handling
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return ResponseModel.toJson(jsonResponse);
      } else {
        throw Exception(ErrorMessage.statusCode(response.statusCode));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ResponseModel?> updatePassword(String _token, String currentPassword,
      String newPassword, String confirmPassword) async {
    try {
      final response =
          await http.post(Uri.parse(_baseUrl + '/auth/change-password'),
              headers: {
                'Authorization': 'Bearer $_token',
                'Content-Type': 'application/json',
                'Accept': 'application/json'
              },
              body: jsonEncode(<dynamic, dynamic>{
                'current_password': currentPassword,
                'password': newPassword,
                'password_confirmation': confirmPassword,
              }));
      print(response.body);

      // Error handling
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return ResponseModel.toJson(jsonResponse);
      } else {
        throw Exception(ErrorMessage.statusCode(response.statusCode));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
