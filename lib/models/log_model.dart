import 'package:tukangku/models/user_model.dart';

class UserLogModel {
  int? id;
  String? type, description;
  User? user;

  UserLogModel({this.id, this.type, this.description, this.user});

  factory UserLogModel.fromJson(Map<String, dynamic> json) {
    return UserLogModel(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['description'] = this.description;
    data['user'] = this.user!.toJson();
    return data;
  }
}

class GPSLogModel {
  final int? id;
  final String? invoiceId, paymentCode, address, latitude, longitude;

  GPSLogModel(
      {this.id,
      this.invoiceId,
      this.paymentCode,
      this.address,
      this.latitude,
      this.longitude});

  factory GPSLogModel.fromJson(Map<String, dynamic> json) {
    return GPSLogModel(
      id: json['id'],
      invoiceId: json['invoice_id'],
      paymentCode: json['payment_code'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
