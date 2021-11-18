import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/transaction_model.dart';
import 'package:tukangku/utils/error_message.dart';

class TransactionRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<List<TransactionModel>?> getTransactions(String _token,
      {int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl + '/transactions?page=$page&limit=$limit'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Accept': 'application/json',
        },
      );
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<TransactionModel> listTransactions =
            iterable.map((e) => TransactionModel.fromJson(e)).toList();
        return listTransactions;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ResponseModel?> confirmTransactionDetail(
      String _token, TransactionDetail transactionDetail) async {
    try {
      final response = await http.post(
          Uri.parse(
              _baseUrl + '/transaction/detail/confirm/${transactionDetail.id}'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'employee_id': transactionDetail.employeeModel!.id!,
            'type_work_duration': transactionDetail.typeWorkDuration,
            'work_duration': transactionDetail.workDuration,
            'salary_employee': transactionDetail.salaryEmployee,
            'description': transactionDetail.description
          }));
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

  Future<ResponseModel?> cancelTransactionDetail(String _token, int id) async {
    try {
      final response = await http.delete(
          Uri.parse(_baseUrl + '/transaction/detail/cancel/${id.toString()}'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json'
          });
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

  Future<ResponseModel?> confirmTransaction(String _token, int id) async {
    try {
      final response = await http.delete(
          Uri.parse(_baseUrl + '/transaction/confirm/${id.toString()}'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json'
          });
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

  Future<ResponseModel?> cancelTransaction(String _token, int id) async {
    try {
      final response = await http.delete(
          Uri.parse(_baseUrl + '/transaction/cancel/${id.toString()}'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json'
          });
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
}
