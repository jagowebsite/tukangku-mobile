import 'package:tukangku/models/user_model.dart';

class ComplainModel {
  int? id, orderId;
  String? description, status;
  User? user;

  ComplainModel(
      {this.id, this.orderId, this.description, this.status, this.user});

  factory ComplainModel.fromJson(Map<String, dynamic> json) {
    return ComplainModel(
      id: json['id'],
      orderId: json['order_id'],
      description: json['description'],
      status: json['status'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['description'] = this.description;
    data['status'] = this.status;
    data['user'] = this.user!.toJson();
    return data;
  }
}
