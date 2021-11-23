import 'package:tukangku/models/service_model.dart';

class CartModel {
  ServiceModel? serviceModel;
  int? quantity, totalPrice;
  String? description;

  CartModel(
      {this.quantity, this.serviceModel, this.totalPrice, this.description});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        quantity: json['quantity'],
        description: json['description'],
        serviceModel: json['service'] != null
            ? ServiceModel.fromJson(json['service'])
            : null,
        totalPrice: json['total_price']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['description'] = this.description;
    data['total_price'] = this.totalPrice;
    data['service'] = this.serviceModel!.toJson();
    return data;
  }
}

class ListCartModel {
  List<CartModel>? listCarts;

  ListCartModel({this.listCarts});

  factory ListCartModel.fromJson(Map<String, dynamic> json) {
    return ListCartModel(
        listCarts: json["carts"] != null
            ? List<CartModel>.from(
                json["carts"].map((e) => CartModel.fromJson(e)))
            : null);
  }
}
