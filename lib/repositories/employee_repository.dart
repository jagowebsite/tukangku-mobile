import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart' show ByteData;
import 'package:http/http.dart' as http;
import 'package:tukangku/models/employee_model.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:path/path.dart';
import 'package:tukangku/utils/error_message.dart';

class EmployeeRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<List<EmployeeModel>?> getEmployees(String _token,
      {int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(
          Uri.parse(_baseUrl + '/employees?page=$page&limit=$limit'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json'
          });
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<EmployeeModel> listEmployees =
            iterable.map((e) => EmployeeModel.fromJson(e)).toList();
        return listEmployees;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ResponseModel?> createEmployee(
      String _token, EmployeeModel employeeModel) async {
    try {
      // Create multipart request
      // Digunakan untuk mengirim request berupa file
      http.MultipartRequest request = http.MultipartRequest(
          'POST', Uri.parse(_baseUrl + '/employee/create'));
      print(employeeModel.categoryService!.id.toString());
      // Request input data
      request.fields['category_service_id'] =
          employeeModel.categoryService!.id.toString();
      request.fields['name'] = employeeModel.name!;
      request.fields['address'] = employeeModel.address!;
      request.fields['number'] = employeeModel.number!;
      request.fields['is_ready'] = employeeModel.isReady! ? '1' : '0';
      request.fields['status'] = employeeModel.status!;
      print(request.fields);

      if (employeeModel.imageFile != null) {
        // Convert file type to byte data
        final byte = await employeeModel.imageFile!.readAsBytes();
        ByteData byteData = byte.buffer.asByteData();
        List<int> byteImage = byteData.buffer.asUint8List();

        // Set request value
        request.files.add(http.MultipartFile.fromBytes('images', byteImage,
            filename: basename(employeeModel.imageFile!.path)));
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

  Future<ResponseModel?> updateEmployee(
      String _token, EmployeeModel employeeModel) async {
    try {
      // Create multipart request
      // Digunakan untuk mengirim request berupa file
      http.MultipartRequest request = http.MultipartRequest(
          'POST', Uri.parse(_baseUrl + '/employee/update/${employeeModel.id}'));

      // Request input data
      request.fields['category_service_id'] =
          employeeModel.categoryService!.id.toString();
      request.fields['name'] = employeeModel.name!;
      request.fields['address'] = employeeModel.address!;
      request.fields['number'] = employeeModel.number!;
      request.fields['is_ready'] = employeeModel.isReady! ? '1' : '0';
      request.fields['status'] = employeeModel.status!;

      // Convert file type to byte data
      final byte = await employeeModel.imageFile!.readAsBytes();
      ByteData byteData = byte.buffer.asByteData();
      List<int> byteImage = byteData.buffer.asUint8List();

      // Set request value
      request.files.add(http.MultipartFile.fromBytes('images', byteImage,
          filename: basename(employeeModel.imageFile!.path)));
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

  Future<ResponseModel?> deleteEmployee(
      String _token, EmployeeModel employeeModel) async {
    try {
      final response = await http.delete(
          Uri.parse(_baseUrl + '/employee/delete/${employeeModel.id}'),
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
