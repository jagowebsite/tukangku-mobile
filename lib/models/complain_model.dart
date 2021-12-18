import 'package:tukangku/models/user_model.dart';

class ComplainModel {
  int? id, orderId;
  String? description, status, createdAt;
  User? user;

  ComplainModel(
      {this.id,
      this.orderId,
      this.description,
      this.status,
      this.user,
      this.createdAt});

  factory ComplainModel.fromJson(Map<String, dynamic> json) {
    return ComplainModel(
      id: json['id'],
      orderId: json['order_id'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['description'] = this.description;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['user'] = this.user!.toJson();
    return data;
  }
}
