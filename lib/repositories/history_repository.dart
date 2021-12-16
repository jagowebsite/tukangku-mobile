import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tukangku/models/history_model.dart';
import 'package:tukangku/models/report_model.dart';

class HistoryRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<List<HistoryEmployeeModel>?> getHistoryEmployee(String _token,
      {int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(
          Uri.parse(_baseUrl + '/history/employee?page=$page&limit=$limit'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
          });
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<HistoryEmployeeModel> listHistoryEmployees =
            iterable.map((e) => HistoryEmployeeModel.fromJson(e)).toList();
        return listHistoryEmployees;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<ReportModel>?> getHistoryConsumen(String _token,
      {int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(
          Uri.parse(_baseUrl + '/history/transaction?page=$page&limit=$limit'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
          });
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<ReportModel> listHistoryConsumens =
            iterable.map((e) => ReportModel.fromJson(e)).toList();
        return listHistoryConsumens;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
