import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/user_model.dart';
import 'package:flutter/services.dart' show ByteData;
import 'package:path/path.dart';
import 'package:tukangku/utils/error_message.dart';

class UserDataRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<List<User>?> getUserData(String _token,
      {int page = 1, int limit = 10, bool isConsumen = false}) async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl +
            '/user-data?page=$page&limit=$limit&is_consumen=${isConsumen ? 1 : 0}'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Accept': 'application/json',
        },
      );
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<User> listUsers = iterable.map((e) => User.fromJson(e)).toList();
        return listUsers;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ResponseModel?> createUserData(String _token, User user) async {
    try {
      // Create multipart request
      // Digunakan untuk mengirim request berupa file
      http.MultipartRequest request = http.MultipartRequest(
          'POST', Uri.parse(_baseUrl + '/user-data/create'));

      // Request input data
      request.fields['name'] = user.name!;
      request.fields['email'] = user.email!;
      request.fields['date_of_birth'] = user.dateOfBirth!;
      request.fields['address'] = user.address!;
      request.fields['password'] = user.password!;
      request.fields['password_confirmation'] = user.passwordConfirmation!;
      request.fields['number'] = user.number!;
      request.fields['user_role_id'] = user.roleAccessModel!.id!.toString();

      // Convert image file type to byte data
      if (user.imageFile != null) {
        final byte = await user.imageFile!.readAsBytes();
        ByteData byteData = byte.buffer.asByteData();
        List<int> byteImage = byteData.buffer.asUint8List();

        // Set request value
        request.files.add(http.MultipartFile.fromBytes('images', byteImage,
            filename: basename(user.imageFile!.path)));
      }

      if (user.ktpImageFile != null) {
        // Convert ktp file type to byte data
        final byteKTP = await user.ktpImageFile!.readAsBytes();
        ByteData byteDataKTP = byteKTP.buffer.asByteData();
        List<int> byteImageKTP = byteDataKTP.buffer.asUint8List();

        request.files.add(http.MultipartFile.fromBytes(
            'ktp_image', byteImageKTP,
            filename: basename(user.ktpImageFile!.path)));
      }

      request.headers['Authorization'] = "Bearer $_token";
      request.headers['Accept'] = "application/json";

      // Send request
      http.StreamedResponse streamedResponse = await request.send();
      final response =
          await http.Response.fromStream(streamedResponse); // get body response
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
    }
  }

  Future<ResponseModel?> updateUserData(String _token, User user) async {
    try {
      // Create multipart request
      // Digunakan untuk mengirim request berupa file
      http.MultipartRequest request = http.MultipartRequest(
          'POST', Uri.parse(_baseUrl + '/user-data/update/${user.id}'));

      // Request input data
      request.fields['name'] = user.name!;
      // request.fields['email'] = user.email!;
      request.fields['date_of_birth'] = user.dateOfBirth!;
      request.fields['address'] = user.address!;
      // request.fields['password'] = user.password!;
      // request.fields['password_confirmation'] = user.passwordConfirmation!;
      request.fields['number'] = user.number!;
      request.fields['user_role_id'] = user.roleAccessModel!.id!.toString();

      // Convert image file type to byte data

      if (user.imageFile != null) {
        final byte = await user.imageFile!.readAsBytes();
        ByteData byteData = byte.buffer.asByteData();
        List<int> byteImage = byteData.buffer.asUint8List();

        // Set request value
        request.files.add(http.MultipartFile.fromBytes('images', byteImage,
            filename: basename(user.imageFile!.path)));
      }

      if (user.ktpImageFile != null) {
        // Convert ktp file type to byte data
        final byteKTP = await user.ktpImageFile!.readAsBytes();
        ByteData byteDataKTP = byteKTP.buffer.asByteData();
        List<int> byteImageKTP = byteDataKTP.buffer.asUint8List();

        request.files.add(http.MultipartFile.fromBytes(
            'ktp_image', byteImageKTP,
            filename: basename(user.ktpImageFile!.path)));
      }

      request.headers['Authorization'] = "Bearer $_token";
      request.headers['Accept'] = "application/json";

      // Send request
      http.StreamedResponse streamedResponse = await request.send();
      final response =
          await http.Response.fromStream(streamedResponse); // get body response
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
    }
  }

  Future<ResponseModel?> changePasswordUserData(
      String _token, int id, String newPassword, String confirmPassword) async {
    try {
      final response = await http.post(
          Uri.parse(_baseUrl + '/user-data/change-password/${id.toString()}'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: jsonEncode(<dynamic, dynamic>{
            'password': newPassword,
            'password_confirmation': confirmPassword,
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
    }
  }

  Future<ResponseModel?> deleteUserData(String _token, int id) async {
    try {
      final response = await http.delete(
          Uri.parse(_baseUrl + '/user-data/delete/${id.toString()}'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json'
          });
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
    }
  }
}
