import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/models/filter_service_model.dart';
import 'package:tukangku/models/service_model.dart';

class ServiceRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<List<ServiceModel>?> getServices(
      {FilterServiceModel? filterService, int page = 1, int limit = 10}) async {
    String q = '';
    int? categoryId;
    try {
      if (filterService != null) {
        q = filterService.q ?? '';
        categoryId = filterService.categoryService != null ? filterService.categoryService!.id : null;
      }
      
      final response = await http
          .get(Uri.parse(_baseUrl + '/services?q=$q&page=$page&limit=$limit&category_id=${(categoryId ?? "")}'));

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

  Future<ServiceModel?> getServiceDetail({String? token, int? id}) async {
    try {
      final response = await http.get(
          Uri.parse(_baseUrl + '/service/show/' + id.toString()),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json'
          });
      // print(response.body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['data'];
        ServiceModel transactionModel = ServiceModel.fromJson(jsonData);
        return transactionModel;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
