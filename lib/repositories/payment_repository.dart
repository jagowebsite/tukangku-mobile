import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/models/payment_model.dart';
import 'package:flutter/services.dart' show ByteData;
import 'package:path/path.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/utils/error_message.dart';

class PaymentRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<List<PaymentModel>?> getPayments(String _token,
      {int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl + '/payments?page=$page&limit=$limit'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Accept': 'application/json',
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<PaymentModel> listPayments =
            iterable.map((e) => PaymentModel.fromJson(e)).toList();
        return listPayments;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ResponseModel?> createPayment(
      String _token, PaymentModel paymentModel) async {
    try {
      // Create multipart request
      // Digunakan untuk mengirim request berupa file
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(_baseUrl + '/banner/create'));

      // Request input data
      request.fields['user_id'] = paymentModel.user!.id.toString();
      request.fields['transaction_id'] =
          paymentModel.transactionModel!.id.toString();
      request.fields['type'] = paymentModel.type!;
      request.fields['type_transfer'] = paymentModel.typeTransfer!;
      request.fields['bank_number'] = paymentModel.bankNumber!;
      request.fields['bank_name'] = paymentModel.bankName!;
      request.fields['account_name'] = paymentModel.accountName!;
      request.fields['longitude'] = paymentModel.longitude!;
      request.fields['latitude'] = paymentModel.latitude!;
      request.fields['total_payment'] = paymentModel.totalPayment!.toString();
      request.fields['description'] = paymentModel.description!;
      request.fields['address'] = paymentModel.address!;

      // Convert file type to byte data
      final byteUser = await paymentModel.imageUserFie!.readAsBytes();
      ByteData byteDataUser = byteUser.buffer.asByteData();
      List<int> byteImageUser = byteDataUser.buffer.asUint8List();

      final bytePayment = await paymentModel.imageUserFie!.readAsBytes();
      ByteData byteDataPayment = bytePayment.buffer.asByteData();
      List<int> byteImagePayment = byteDataPayment.buffer.asUint8List();

      // Set request value
      request.files.add(http.MultipartFile.fromBytes(
          'images_user', byteImageUser,
          filename: basename(paymentModel.imageUserFie!.path)));
      request.files.add(http.MultipartFile.fromBytes(
          'images_payment', byteImagePayment,
          filename: basename(paymentModel.imagePaymentFile!.path)));

      request.headers['Authorization'] = "Bearer $_token";
      request.headers['Accept'] = "application/json";

      // Send request
      http.StreamedResponse streamedResponse = await request.send();
      final response =
          await http.Response.fromStream(streamedResponse); // get body response
      // print(response.body);

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

  Future<ResponseModel?> updatePayment(
      String _token, PaymentModel paymentModel) async {
    try {
      // Create multipart request
      // Digunakan untuk mengirim request berupa file
      http.MultipartRequest request = http.MultipartRequest(
          'POST', Uri.parse(_baseUrl + '/payment/update/${paymentModel.id}'));

      // Request input data
      request.fields['user_id'] = paymentModel.user!.id.toString();
      request.fields['transaction_id'] =
          paymentModel.transactionModel!.id.toString();
      request.fields['type'] = paymentModel.type!;
      request.fields['type_transfer'] = paymentModel.typeTransfer!;
      request.fields['bank_number'] = paymentModel.bankNumber!;
      request.fields['bank_name'] = paymentModel.bankName!;
      request.fields['account_name'] = paymentModel.accountName!;
      request.fields['longitude'] = paymentModel.longitude!;
      request.fields['latitude'] = paymentModel.latitude!;
      request.fields['total_payment'] = paymentModel.totalPayment!.toString();
      request.fields['description'] = paymentModel.description!;
      request.fields['address'] = paymentModel.address!;

      // Convert file type to byte data
      final byteUser = await paymentModel.imageUserFie!.readAsBytes();
      ByteData byteDataUser = byteUser.buffer.asByteData();
      List<int> byteImageUser = byteDataUser.buffer.asUint8List();

      final bytePayment = await paymentModel.imageUserFie!.readAsBytes();
      ByteData byteDataPayment = bytePayment.buffer.asByteData();
      List<int> byteImagePayment = byteDataPayment.buffer.asUint8List();

      // Set request value
      request.files.add(http.MultipartFile.fromBytes(
          'images_user', byteImageUser,
          filename: basename(paymentModel.imageUserFie!.path)));
      request.files.add(http.MultipartFile.fromBytes(
          'images_payment', byteImagePayment,
          filename: basename(paymentModel.imagePaymentFile!.path)));

      request.headers['Authorization'] = "Bearer $_token";
      request.headers['Accept'] = "application/json";

      // Send request
      http.StreamedResponse streamedResponse = await request.send();
      final response =
          await http.Response.fromStream(streamedResponse); // get body response
      // print(response.body);

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

  Future<ResponseModel?> confirmPayment(String _token, int id) async {
    try {
      final response = await http
          .patch(Uri.parse(_baseUrl + '/payment/confirm/$id'), headers: {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
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

  Future<ResponseModel?> cancelPayment(String _token, int id) async {
    try {
      final response = await http
          .patch(Uri.parse(_baseUrl + '/payment/cancel/$id'), headers: {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
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
