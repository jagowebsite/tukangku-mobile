import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tukangku/models/location_model.dart';
import 'package:tukangku/utils/error_message.dart';

class LocationRepository {
  final _baseUrlLoc = dotenv.env['API_NOMINATIM_LOC'].toString();

  Future<LocationInfoModel?> getLocationDetail(
      LocationModel locationModel) async {
    try {
      final response = await http.post(Uri.parse(_baseUrlLoc +
          '?format=json&lat=${locationModel.latitude}&lon=${locationModel.longitude}&zoom=18&addressdetails=1'));
      // print(response.body);
      // Error handling
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return LocationInfoModel.fromJson(jsonResponse);
      } else {
        throw Exception(ErrorMessage.statusCode(response.statusCode));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
