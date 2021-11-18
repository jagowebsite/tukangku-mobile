import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tukangku/models/cart_model.dart';

class CartRepository {
  Future addToCart(CartModel cartModel) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    String? cartsPref = _prefs.getString("carts");

    ListCartModel listCarts = ListCartModel.fromJson(json.decode(cartsPref!));

    // _prefs.setString("carts", listCarts.listCarts!.toJson());
  }
}
