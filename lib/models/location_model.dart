class LocationModel {
  double latitude, longitude;
  LocationModel({this.latitude = -7.2849593, this.longitude = 112.6921382});
}

class LocationInfoModel {
  int? id;
  String? lat, lon, displayName;

  LocationInfoModel({this.id, this.lat, this.lon, this.displayName});

  factory LocationInfoModel.fromJson(Map<String, dynamic> json) {
    return LocationInfoModel(
      id: json['place_id'],
      lat: json['lat'],
      lon: json['lon'],
      displayName: json['display_name'],
    );
  }
}
