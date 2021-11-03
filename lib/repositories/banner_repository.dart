import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart' show ByteData;
import 'package:http/http.dart' as http;
import 'package:tukangku/models/banner_model.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/utils/error_message.dart';
import 'package:path/path.dart';

class BannerRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<List<BannerModel>?> getBanners({int page = 1, int limit = 10}) async {
    try {
      final response = await http
          .get(Uri.parse(_baseUrl + '/banners?page=$page&limit=$limit'));
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

  Future<ResponseModel?> createBanner(
      String _token, BannerModel bannerModel) async {
    try {
      // Create multipart request
      // Digunakan untuk mengirim request berupa file
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(_baseUrl + '/banner/create'));

      // Request input data
      request.fields['name'] = bannerModel.name!;
      request.fields['url_asset'] = bannerModel.urlAsset!;
      request.fields['is_active'] = bannerModel.isActive! ? '1' : '0';

      // Convert file type to byte data
      final byte = await bannerModel.imageFile!.readAsBytes();
      ByteData byteData = byte.buffer.asByteData();
      List<int> byteImage = byteData.buffer.asUint8List();

      // Set request value
      request.files.add(http.MultipartFile.fromBytes('images', byteImage,
          filename: basename(bannerModel.imageFile!.path)));
      request.headers['Authorization'] = "Bearer $_token";
      request.headers['Accept'] = "application/json";

      // Send request
      http.StreamedResponse streamedResponse = await request.send();
      final response =
          await http.Response.fromStream(streamedResponse); // get body response
      // print(response.body);

      // Error handling
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return ResponseModel.toJson(jsonResponse);
      } else {
        throw Exception(ErrorMessage.statusCode(response.statusCode));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ResponseModel?> updateBanner(
      String _token, BannerModel bannerModel) async {
    try {
      // Create multipart request
      // Digunakan untuk mengirim request berupa file
      http.MultipartRequest request = http.MultipartRequest(
          'POST', Uri.parse(_baseUrl + '/banner/update/${bannerModel.id}'));

      // Request input data
      request.fields['name'] = bannerModel.name!;
      request.fields['url_asset'] = bannerModel.urlAsset!;
      request.fields['is_active'] = bannerModel.isActive! ? '1' : '0';

      // Convert file type to byte data
      final byte = await bannerModel.imageFile!.readAsBytes();
      ByteData byteData = byte.buffer.asByteData();
      List<int> byteImage = byteData.buffer.asUint8List();

      // Set request value
      request.files.add(http.MultipartFile.fromBytes('images', byteImage,
          filename: basename(bannerModel.imageFile!.path)));
      request.headers['Authorization'] = "Bearer $_token";
      request.headers['Accept'] = "application/json";

      // Send request
      http.StreamedResponse streamedResponse = await request.send();
      final response =
          await http.Response.fromStream(streamedResponse); // get body response
      print(response.body);

      // Error handling
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return ResponseModel.toJson(jsonResponse);
      } else {
        throw Exception(ErrorMessage.statusCode(response.statusCode));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ResponseModel?> deleteBanner(
      String _token, BannerModel bannerModel) async {
    try {
      final response = await http.delete(
          Uri.parse(_baseUrl + '/banner/delete/${bannerModel.id}'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json'
          });
      print(response.body);
      print(response.statusCode);

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
