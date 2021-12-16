import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tukangku/models/report_model.dart';

class ReportRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<List<ReportModel>?> getReportService(String _token,
      {int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(
          Uri.parse(_baseUrl + '/report/service?page=$page&limit=$limit'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
          });
      // print(response.statusCode);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<ReportModel> listReportServices =
            iterable.map((e) => ReportModel.fromJson(e)).toList();
        return listReportServices;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<ReportModel>?> getReportAll(String _token,
      {int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(
          Uri.parse(_baseUrl + '/report/all?page=$page&limit=$limit'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
          });
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<ReportModel> listReportAll =
            iterable.map((e) => ReportModel.fromJson(e)).toList();
        return listReportAll;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
