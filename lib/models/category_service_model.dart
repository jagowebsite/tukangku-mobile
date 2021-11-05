import 'dart:io';

class CategoryServiceModel {
  int? id;
  String? name, images;
  File? imageFile;

  CategoryServiceModel({this.id, this.name, this.images, this.imageFile});

  factory CategoryServiceModel.fromJson(Map<String, dynamic> json) {
    return CategoryServiceModel(
      id: json['id'],
      name: json['name'],
      images: json['images'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['images'] = this.images;
    return data;
  }
}
