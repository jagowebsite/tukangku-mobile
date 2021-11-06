import 'dart:io';

import 'package:tukangku/models/category_service_model.dart';

class ServiceModel {
  int? id, price;
  String? name, typeQuantity, description, status;
  List<String>? images;
  CategoryServiceModel? categoryService;
  List<File>? imageFiles;

  ServiceModel(
      {this.id,
      this.price,
      this.name,
      this.typeQuantity,
      this.description,
      this.status,
      this.images,
      this.imageFiles,
      this.categoryService});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      price: json['price'],
      name: json['name'],
      typeQuantity: json['type_quantity'],
      description: json['description'],
      status: json['status'],
      images: json["images"] != null ? List<String>.from(json["images"]) : null,
      categoryService: json['category'] != null
          ? CategoryServiceModel.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['name'] = this.name;
    data['type_quantity'] = this.typeQuantity;
    data['description'] = this.description;
    data['status'] = this.status;
    data['images'] = this.images;
    data['category'] = this.categoryService!.toJson();
    return data;
  }
}
