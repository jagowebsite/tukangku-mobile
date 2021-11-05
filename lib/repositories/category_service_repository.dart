import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/models/category_service_model.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/utils/error_message.dart';
import 'package:flutter/services.dart' show ByteData;
import 'package:path/path.dart';

class CategoryServiceRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<List<CategoryServiceModel>?> getCategoryServices(
      {int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(
          Uri.parse(_baseUrl + '/category-services?page=$page&limit=$limit'));
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

  Future<ResponseModel?> createCategoryService(
      String _token, CategoryServiceModel categoryServiceModel) async {
    try {
      // Create multipart request
      // Digunakan untuk mengirim request berupa file
      http.MultipartRequest request = http.MultipartRequest(
          'POST', Uri.parse(_baseUrl + '/category-service/create'));

      // Request input data
      request.fields['name'] = categoryServiceModel.name!;

      // Convert file type to byte data
      if (categoryServiceModel.imageFile != null) {
        final byte = await categoryServiceModel.imageFile!.readAsBytes();
        ByteData byteData = byte.buffer.asByteData();
        List<int> byteImage = byteData.buffer.asUint8List();

        // Set request value
        request.files.add(http.MultipartFile.fromBytes('images', byteImage,
            filename: basename(categoryServiceModel.imageFile!.path)));
      }

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

  Future<ResponseModel?> updateCategoryService(
      String _token, CategoryServiceModel categoryServiceModel) async {
    try {
      // Create multipart request
      // Digunakan untuk mengirim request berupa file
      http.MultipartRequest request = http.MultipartRequest(
          'POST',
          Uri.parse(_baseUrl +
              '/category-service/update/${categoryServiceModel.id}'));

      // Request input data
      request.fields['name'] = categoryServiceModel.name!;

      // Convert file type to byte data
      if (categoryServiceModel.imageFile != null) {
        final byte = await categoryServiceModel.imageFile!.readAsBytes();
        ByteData byteData = byte.buffer.asByteData();
        List<int> byteImage = byteData.buffer.asUint8List();

        // Set request value
        request.files.add(http.MultipartFile.fromBytes('images', byteImage,
            filename: basename(categoryServiceModel.imageFile!.path)));
      }

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

  Future<ResponseModel?> deleteCategoryService(
      String _token, CategoryServiceModel categoryServiceModel) async {
    try {
      final response = await http.delete(
          Uri.parse(
              _baseUrl + '/category-service/delete/${categoryServiceModel.id}'),
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
