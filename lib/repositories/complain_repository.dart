import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/models/complain_model.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/utils/error_message.dart';

class ComplainRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<List<ComplainModel>?> getComplains(
      {int page = 1, int limit = 10}) async {
    try {
      final response = await http
          .get(Uri.parse(_baseUrl + '/complains?page=$page&limit=$limit'));
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<ComplainModel> listComplains =
            iterable.map((e) => ComplainModel.fromJson(e)).toList();
        return listComplains;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ResponseModel?> createComplain(
      String _token, ComplainModel complainModel) async {
    try {
      final response = await http.post(Uri.parse(_baseUrl + '/complain/create'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'order_id': complainModel.orderId,
            'description': complainModel.description,
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

  Future<ResponseModel?> updateStatusComplain(
      String _token, ComplainModel complainModel) async {
    try {
      final response = await http.post(
          Uri.parse(_baseUrl + '/complain/status/${complainModel.id}'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'status': complainModel.status,
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
}
