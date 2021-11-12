import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/role_model.dart';
import 'package:tukangku/utils/error_message.dart';

class RoleRepository {
  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<List<RoleAccessModel>?> getRoleAccess(String _token,
      {int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl + '/role-access?page=$page&limit=$limit'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Accept': 'application/json',
        },
      );
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<RoleAccessModel> listRoleAccess =
            iterable.map((e) => RoleAccessModel.fromJson(e)).toList();
        return listRoleAccess;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ResponseModel?> createRoleAccess(
      String _token, RoleAccessModel roleAccessModel) async {
    try {
      final response =
          await http.post(Uri.parse(_baseUrl + '/role-access/create'),
              headers: {
                'Authorization': 'Bearer $_token',
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              },
              body: json.encode({
                'name': roleAccessModel.name,
                'guard_name': roleAccessModel.guardName,
              }));
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

  Future<ResponseModel?> createPermissionToRole(
      String _token,
      RoleAccessModel roleAccessModel,
      RolePermissionModel rolePermissionModel) async {
    try {
      final response = await http.post(
          Uri.parse(
              _baseUrl + '/role-access/add-permission/${roleAccessModel.id}'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: json.encode({'role_permission_id': rolePermissionModel.id}));
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

  Future<ResponseModel?> deletePermissionToRole(
      String _token,
      RoleAccessModel roleAccessModel,
      RolePermissionModel rolePermissionModel) async {
    try {
      final response = await http.delete(
          Uri.parse(_baseUrl +
              '/role-access/delete-permission/${roleAccessModel.id}'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: json.encode({'role_permission_id': rolePermissionModel.id}));
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

  Future<ResponseModel?> updateRoleAccess(
      String _token, RoleAccessModel roleAccessModel) async {
    try {
      // print(_token);
      print('/role-access/update/${roleAccessModel.id}');
      final response = await http.patch(
          Uri.parse(_baseUrl + '/role-access/update/${roleAccessModel.id}'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'name': roleAccessModel.name,
            'guard_name': roleAccessModel.guardName,
          }));
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

  Future<ResponseModel?> deleteRoleAccess(
      String _token, RoleAccessModel roleAccessModel) async {
    try {
      final response = await http.delete(
          Uri.parse(_baseUrl + '/role-access/delete/${roleAccessModel.id}'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json'
          });
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

  Future<List<RolePermissionModel>?> getRolePermission(String _token,
      {int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(
          Uri.parse(_baseUrl + '/role-permission?page=$page&limit=$limit'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
          });
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<RolePermissionModel> listRolePermission =
            iterable.map((e) => RolePermissionModel.fromJson(e)).toList();
        return listRolePermission;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ResponseModel?> createRolePermission(
      String _token, RolePermissionModel rolePermissionModel) async {
    try {
      final response =
          await http.post(Uri.parse(_baseUrl + '/role-permission/create'),
              headers: {
                'Authorization': 'Bearer $_token',
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              },
              body: json.encode({
                'name': rolePermissionModel.name,
                'guard_name': rolePermissionModel.guardName,
              }));
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

  Future<ResponseModel?> updateRolePermission(
      String _token, RolePermissionModel rolePermissionModel) async {
    try {
      final response = await http.patch(
          Uri.parse(
              _baseUrl + '/role-permission/update/${rolePermissionModel.id}'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'name': rolePermissionModel.name,
            'guard_name': rolePermissionModel.guardName,
          }));
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

  Future<ResponseModel?> deleteRolePermission(
      String _token, RolePermissionModel rolePermissionModel) async {
    try {
      final response = await http.delete(
          Uri.parse(
              _baseUrl + '/role-permission/delete/${rolePermissionModel.id}'),
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
