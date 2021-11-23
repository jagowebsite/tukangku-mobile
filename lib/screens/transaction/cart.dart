import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tukangku/hive/cart/cart_hive.dart';
import 'package:tukangku/models/cart_model.dart';
import 'package:tukangku/models/service_model.dart';
import 'package:tukangku/utils/currency_format.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int totalAllPrice = 0;
  late Box cartBox;

  List<CartHive>? listCarts;

  Future getData() async {
    // cartBox.put(2, cartHive2);
    // print(cartBox.keyAt(i));
    listCarts = cartBox.values.toList().cast<CartHive>();
    if (listCarts!.length != 0) {
      cartModels = [];
      for (var i = 0; i < listCarts!.length; i++) {
        cartModels.add(CartModel(
            quantity: listCarts![i].quantity,
            totalPrice: 15000 * listCarts![i].quantity,
            description: listCarts![i].description,
            serviceModel: ServiceModel(
                id: listCarts![i].serviceId,
                name: 'Service Kulkas No $i',
                typeQuantity: 'Jam',
                price: 15000)));
      }
      setState(() {});
    }
  }

  Future initHive() async {
    cartBox = Hive.box<CartHive>('cart');
    getData();
  }

  List<CartModel> cartModels = [
    // CartModel(
    //     quantity: 1,
    //     serviceModel: ServiceModel(
    //         id: 1, name: 'Service Banana', typeQuantity: 'Jam', price: 15000),
    //     totalPrice: 15000),
    // CartModel(
    //     quantity: 1,
    //     serviceModel: ServiceModel(
    //         id: 2, name: 'Service Apple', typeQuantity: 'Jam', price: 14000),
    //     totalPrice: 14000),
  ];

  countTotalPrice() {
    int totalPrice = 0;
    for (var i = 0; i < cartModels.length; i++) {
      int price = cartModels[i].quantity! * cartModels[i].serviceModel!.price!;
      totalPrice = totalPrice + price;
    }
    totalAllPrice = totalPrice;
    setState(() {});
  }

  removeCart(CartModel cart) {
    cartModels
        .removeWhere((item) => item.serviceModel!.id == cart.serviceModel!.id);
    setState(() {});
  }

  addQuantity(CartModel cartModel, int index) {
    CartHive cartHive = CartHive()
      ..description = cartModel.description!
      ..quantity = (cartModel.quantity! + 1)
      ..serviceId = cartModel.serviceModel!.id!;
    cartBox.put(cartBox.keyAt(index), cartHive);
  }

  minusQuantity(CartModel cartModel, int index) {
    CartHive cartHive = CartHive()
      ..description = cartModel.description!
      ..quantity = (cartModel.quantity! - 1)
      ..serviceId = cartModel.serviceModel!.id!;
    cartBox.put(cartBox.keyAt(index), cartHive);
  }

  @override
  void initState() {
    initHive();
    countTotalPrice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Keranjang Saya',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 10, bottom: 60),
              // shrinkWrap: true,
              itemCount: cartModels.length,
              itemBuilder: (context, index) {
                return CartItem(
                  cartModel: cartModels[index],
                  addFunction: () {
                    addQuantity(cartModels[index], index);
                    cartModels[index].quantity =
                        cartModels[index].quantity! + 1;
                    countTotalPrice();
                    setState(() {});
                  },
                  minusFunction: () {
                    if (cartModels[index].quantity! > 0) {
                      minusQuantity(cartModels[index], index);
                      cartModels[index].quantity =
                          cartModels[index].quantity! - 1;
                      countTotalPrice();
                      setState(() {});
                    }
                    if (cartModels[index].quantity! <= 0) {
                      cartBox.delete(cartBox.keyAt(index));
                      removeCart(cartModels[index]);
                    }
                  },
                );
              }),
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.08,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 7,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              currencyId.format(totalAllPrice).toString(),
                              style: TextStyle(
                                  color: Colors.orangeAccent.shade700,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // cartModels[0].quantity = cartModels[0].quantity! + 1;
                          // print(cartModels[0].quantity);
                        },
                        child: Container(
                          color: Colors.orangeAccent.shade700,
                          child: Center(
                            child: Text(
                              'Checkout (${cartModels.length})',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CartItem extends StatefulWidget {
  final CartModel cartModel;
  final Function()? addFunction;
  final Function()? minusFunction;
  const CartItem(
      {Key? key, required this.cartModel, this.addFunction, this.minusFunction})
      : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: size.height * 0.1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://psdfreebies.com/wp-content/uploads/2019/01/Travel-Service-Banner-Ads-Templates-PSD.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.cartModel.serviceModel!.name ?? ''),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'Bebersih',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Text(
                    currencyId.format(widget.cartModel.serviceModel!.price),
                    style: TextStyle(
                        color: Colors.orangeAccent.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: widget.minusFunction,
                        child: Container(
                          width: 30,
                          height: 30,
                          padding: EdgeInsets.all(5),
                          color: Colors.grey.shade200,
                          child: Center(child: Text('-')),
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 30,
                        padding: EdgeInsets.all(5),
                        color: Colors.grey.shade100,
                        child: Center(
                            child: Text(widget.cartModel.quantity.toString())),
                      ),
                      GestureDetector(
                        onTap: widget.addFunction,
                        child: Container(
                          width: 30,
                          height: 30,
                          padding: EdgeInsets.all(5),
                          color: Colors.grey.shade200,
                          child: Center(child: Text('+')),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                            widget.cartModel.serviceModel!.typeQuantity ?? ''),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
