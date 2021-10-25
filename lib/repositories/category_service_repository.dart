import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/models/category_service_model.dart';

class CategoryServiceRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<List<CategoryServiceModel>?> getCategoryServices() async {
    try {
      final response =
          await http.get(Uri.parse(_baseUrl + '/category-services'));
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<CategoryServiceModel> listCategoryService =
            iterable.map((e) => CategoryServiceModel.fromJson(e)).toList();
        return listCategoryService;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
