import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/models/filter_service_model.dart';
import 'package:tukangku/models/service_model.dart';

class MasterServiceRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<List<ServiceModel>?> getServiceMaster(
      {FilterServiceModel? filterService, int page = 1, int limit = 10}) async {
    String q = '';
    try {
      if (filterService != null) {
        q = filterService.q ?? '';
      }
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
