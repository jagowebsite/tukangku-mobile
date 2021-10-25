import 'package:tukangku/models/user_model.dart';

class LogModel {
  int? id;
  String? type, description;
  User? user;

  LogModel({this.id, this.type, this.description, this.user});

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
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
