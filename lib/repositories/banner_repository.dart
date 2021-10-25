import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/models/banner_model.dart';

class BannerRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<List<BannerModel>?> getBanners() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl + '/banners'));
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<BannerModel> listBanner =
            iterable.map((e) => BannerModel.fromJson(e)).toList();
        return listBanner;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
