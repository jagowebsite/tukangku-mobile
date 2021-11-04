import 'dart:io';

import 'package:tukangku/models/category_service_model.dart';

class EmployeeModel {
  int? id;
  String? name, address, number, status, images;
  bool? isReady;
  CategoryServiceModel? categoryService;
  File? imageFile;

  EmployeeModel(
      {this.id,
      this.name,
      this.address,
      this.number,
      this.status,
      this.images,
      this.isReady,
      this.imageFile,
      this.categoryService});

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      number: json['number'],
      status: json['status'],
      images: json['images'],
      categoryService: json['category_service'] != null
          ? CategoryServiceModel.fromJson(json['category_service'])
          : null,
      isReady: json['is_ready'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['number'] = this.number;
    data['status'] = this.status;
    data['images'] = this.images;
    data['category'] = this.categoryService!.toJson();
    data['is_ready'] = this.isReady;
    return data;
  }
}
