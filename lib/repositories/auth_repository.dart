import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tukangku/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/models/register_model.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/user_model.dart';

class AuthRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<LoginData?> login(LoginModel loginModel) async {
    try {
      final response =
          await http.post(Uri.parse(_baseUrl + '/auth/login'), body: {
        'email': loginModel.username,
        'password': loginModel.password,
        'device_name': 'mobile'
      });

      // print(response.body);

      // Error handling
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return LoginData.toJson(jsonResponse['data']);
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception('Koneksi dengan server bermasalah');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ResponseModel?> register(RegisterModel registerModel) async {
    try {
      var response =
          await http.post(Uri.parse(_baseUrl + '/auth/register'), body: {
        'name': registerModel.name,
        'email': registerModel.username,
        'password': registerModel.password,
        'password_confirmation': registerModel.confirmPassword
      });

      // Error handling
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return ResponseModel.toJson(jsonResponse);
      } else {
        throw Exception('Koneksi dengan server bermasalah.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User?> getUser(String _token) async {
    try {
      var response = await http.get(Uri.parse(_baseUrl + '/auth/user'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json'
          });

      // print(response.body);

      // Error handling
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return User.fromJson(jsonResponse['data']);
        }
      } else {
        throw Exception('Response status code : ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ResponseModel?> logout(String _token) async {
    try {
      var response = await http.post(Uri.parse(_baseUrl + '/auth/logout'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json'
          });

      print(response.body);

      // Error handling
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return ResponseModel.toJson(jsonResponse);
      } else {
        print('Response code : ' + response.statusCode.toString());
        throw Exception(response.statusCode == 401
            ? 'Unauthenticated'
            : 'Koneksi dengan server bermasalah');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ResponseModel?> forgotPassword(String email) async {
    try {
      final response = await http.post(
          Uri.parse(_baseUrl + '/auth/reset-password'),
          body: {'email': email});

      // Error handling
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return ResponseModel.toJson(jsonResponse);
      } else {
        throw Exception('Koneksi dengan server bermasalah');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ResponseModel?> resendVerifyEmail(String email) async {
    try {
      final response =
          await http.post(Uri.parse(_baseUrl + '/auth/verify-email'), body: {
        'email': email,
      });

      print(response.body);

      // Error handling
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return ResponseModel.toJson(jsonResponse);
      } else {
        throw Exception('Koneksi dengan server bermasalah');
      }
    } catch (e) {
      throw Exception('Koneksi dengan server bermasalah');
    }
  }

  /// Sharedpreferences
  ///
  /// Merupakan penyimpan data dalam bentuk key-value
  /// Disimpan didalam session lokal user
  /// Mengecek apakah didalam session ada token user
  /// Jika tidak ada, menandakan user belum login
  /// Return String
  Future<String?> hasToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String _token = _prefs.getString("token") ?? "";
    return _token != "" ? _token : null;
  }

  /// Menambahkan token ke dalam session
  /// Token disimpan didalam key "token"
  /// Fungsi ini biasanya dijalankan ketika user berhasil login
  Future setToken(String _token) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("token", _token);
  }

  /// Menghapus token dari session (cache)
  /// Fungsi ini biasanya dijalankan ketika user logout
  Future unSetToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("token", "");
  }
}
