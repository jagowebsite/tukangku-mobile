import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/models/log_model.dart';

class LogRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<List<UserLogModel>?> getUserLogs(String _token,
      {int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(
          Uri.parse(_baseUrl + '/user-logs?page=$page&limit=$limit'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
          });
      print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<UserLogModel> listUserLogs =
            iterable.map((e) => UserLogModel.fromJson(e)).toList();
        return listUserLogs;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<GPSLogModel>?> getGPSLogs({int page = 1, int limit = 10}) async {
    try {
      final response = await http
          .get(Uri.parse(_baseUrl + '/gps-logs?page=$page&limit=$limit'));
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<GPSLogModel> listGPSLogs =
            iterable.map((e) => GPSLogModel.fromJson(e)).toList();
        return listGPSLogs;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
