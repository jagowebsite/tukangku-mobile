import 'dart:io';

import 'package:tukangku/models/role_model.dart';

class User {
  int? id, roleAccessId;
  String? email,
      password,
      passwordConfirmation,
      name,
      dateOfBirth,
      address,
      number,
      images,
      ktpImage;
  File? imageFile, ktpImageFile;
  RoleAccessModel? roleAccessModel;

  User(
      {this.id,
      this.roleAccessId,
      this.email,
      this.password,
      this.name,
      this.passwordConfirmation,
      this.dateOfBirth,
      this.address,
      this.number,
      this.images,
      this.imageFile,
      this.ktpImageFile,
      this.ktpImage,
      this.roleAccessModel});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      roleAccessId: json['role_access_id'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      dateOfBirth: json['date_of_birth'],
      address: json['address'],
      number: json['number'],
      images: json['images'],
      ktpImage: json['ktp_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role_access_id'] = this.roleAccessId;
    data['email'] = this.email;
    data['password'] = this.password;
    data['name'] = this.name;
    data['date_of_birth'] = this.dateOfBirth;
    data['address'] = this.address;
    data['number'] = this.number;
    data['images'] = this.images;
    data['ktp_image'] = this.ktpImage;
    return data;
  }
}
