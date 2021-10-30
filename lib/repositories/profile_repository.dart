import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/user_model.dart';
import 'package:tukangku/utils/error_message.dart';

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
}
