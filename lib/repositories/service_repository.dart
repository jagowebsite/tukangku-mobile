import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/models/service_model.dart';

class ServiceRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<List<ServiceModel>?> getServices(
      {String q = '', int page = 1, int limit = 10}) async {
    try {
      final response = await http
          .get(Uri.parse(_baseUrl + '/services?q=$q&page=$page&limit=$limit'));

      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<ServiceModel> listServices =
            iterable.map((e) => ServiceModel.fromJson(e)).toList();
        return listServices;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
