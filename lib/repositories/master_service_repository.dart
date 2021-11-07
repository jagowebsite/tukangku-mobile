import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/models/filter_service_model.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/service_model.dart';
import 'package:flutter/services.dart' show ByteData;
import 'package:path/path.dart';
import 'package:tukangku/utils/error_message.dart';

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

  Future<ResponseModel?> createMasterService(
      String _token, ServiceModel serviceModel) async {
    try {
      // Create multipart request
      // Digunakan untuk mengirim request berupa file
      http.MultipartRequest request = http.MultipartRequest(
          'POST', Uri.parse(_baseUrl + '/service/create'));

      // Request input data
      request.fields['name'] = serviceModel.name!;
      request.fields['category_id'] =
          serviceModel.categoryService!.id.toString();
      request.fields['type_quantity'] = serviceModel.typeQuantity!;
      request.fields['price'] = serviceModel.price!.toString();
      request.fields['description'] = serviceModel.description!.toString();
      request.fields['status'] = serviceModel.status!.toString();

      // Looping untuk multiple image yang dikirim
      // Setiap item request image akan dimasukkan dalam request name array
      if (serviceModel.imageFiles != null) {
        for (var i = 0; i < serviceModel.imageFiles!.length; i++) {
          final byte = await serviceModel.imageFiles![i].readAsBytes();
          ByteData byteData = byte.buffer.asByteData();
          List<int> byteImage = byteData.buffer.asUint8List();

          request.files.add(http.MultipartFile.fromBytes('images[]', byteImage,
              filename: basename(serviceModel.imageFiles![i].path)));
        }
      }

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

  Future<ResponseModel?> updateMasterService(
      String _token, ServiceModel serviceModel) async {
    try {
      // Create multipart request
      // Digunakan untuk mengirim request berupa file
      http.MultipartRequest request = http.MultipartRequest(
          'POST', Uri.parse(_baseUrl + '/service/update/${serviceModel.id}'));

      // Request input data
      request.fields['name'] = serviceModel.name!;
      request.fields['category_id'] =
          serviceModel.categoryService!.id.toString();
      request.fields['type_quantity'] = serviceModel.typeQuantity!;
      request.fields['price'] = serviceModel.price!.toString();
      request.fields['description'] = serviceModel.description!.toString();
      request.fields['status'] = serviceModel.status!.toString();

      // Looping untuk multiple image yang dikirim
      // Setiap item request image akan dimasukkan dalam request name array
      print(serviceModel.imageFiles);
      if (serviceModel.imageFiles != null) {
        for (var i = 0; i < serviceModel.imageFiles!.length; i++) {
          final byte = await serviceModel.imageFiles![i].readAsBytes();
          ByteData byteData = byte.buffer.asByteData();
          List<int> byteImage = byteData.buffer.asUint8List();

          request.files.add(http.MultipartFile.fromBytes('images[]', byteImage,
              filename: basename(serviceModel.imageFiles![i].path)));
        }
      }

      request.headers['Authorization'] = "Bearer $_token";
      request.headers['Accept'] = "application/json";

      // Send request
      http.StreamedResponse streamedResponse = await request.send();
      final response =
          await http.Response.fromStream(streamedResponse); // get body response
      print(response.body);

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

  Future<ResponseModel?> deleteMasterService(
      String _token, ServiceModel serviceModel) async {
    try {
      final response = await http.delete(
          Uri.parse(_baseUrl + '/service/delete/${serviceModel.id}'),
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
