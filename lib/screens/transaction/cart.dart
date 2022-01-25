import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tukangku/hive/cart/cart_hive.dart';
import 'package:tukangku/models/cart_model.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/service_model.dart';
import 'package:tukangku/models/transaction_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/service_repository.dart';
import 'package:tukangku/repositories/transaction_repository.dart';
import 'package:tukangku/screens/widgets/custom_cached_image.dart';
import 'package:tukangku/utils/currency_format.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  ServiceRepository _serviceRepo = ServiceRepository();
  AuthRepository _authRepo = AuthRepository();
  TransactionRepository _transactionRepo = TransactionRepository();
  int totalAllPrice = 0;
  late Box cartBox;
  bool isLoad = false;

  List<CartHive>? listCarts;

  Future<ServiceModel?> getServiceDetail(int id) async {
    String? _token = await _authRepo.hasToken();
    ServiceModel? serviceModel =
        await _serviceRepo.getServiceDetail(token: _token!, id: id);
    return serviceModel;
  }

  Future getData() async {
    listCarts = cartBox.values.toList().cast<CartHive>();
    if (listCarts!.length != 0) {
      cartModels = [];
      for (var i = 0; i < listCarts!.length; i++) {
        ServiceModel? serviceModel =
            await getServiceDetail(listCarts![i].serviceId);
        if (serviceModel != null) {
          cartModels.add(CartModel(
              quantity: listCarts![i].quantity,
              totalPrice: serviceModel.price! * listCarts![i].quantity,
              description: listCarts![i].description,
              serviceModel: ServiceModel(
                  id: listCarts![i].serviceId,
                  name: serviceModel.name,
                  images: serviceModel.images,
                  typeQuantity: serviceModel.typeQuantity,
                  price: serviceModel.price)));
        }
      }
      setState(() {});
    }
  }

  Future checkOut() async {
    if (cartBox.length != 0) {
      setState(() {
        isLoad = true;
      });
      List<CreateTransaction> createTransactions = [];
      for (var i = 0; i < cartModels.length; i++) {
        createTransactions.add(CreateTransaction(
            serviceId: cartModels[i].serviceModel!.id,
            quantity: cartModels[i].quantity,
            price: cartModels[i].serviceModel!.price,
            totalPrice:
                cartModels[i].quantity! * cartModels[i].serviceModel!.price!,
            description: cartModels[i].description));
      }

      String? _token = await _authRepo.hasToken();
      ResponseModel? response =
          await _transactionRepo.createTransaction(_token!, createTransactions);
      if (response != null) {
        if (response.status == 'success') {
          cartBox.clear();
          cartModels = [];
          CustomSnackbar.showSnackbar(
              context, response.message!, SnackbarType.success);
          Navigator.of(context).pushNamed('/my-transaction');
        } else {
          CustomSnackbar.showSnackbar(
              context, response.message!, SnackbarType.error);
        }
      } else {
        CustomSnackbar.showSnackbar(
            context,
            'Pesanan gagal dilakukan, silahkan coba kembali',
            SnackbarType.error);
      }
      setState(() {
        isLoad = false;
      });
    } else {
      CustomSnackbar.showSnackbar(
          context,
          'Silahkan pilih layanan yang ingin dipesan terlebih dahulu',
          SnackbarType.warning);
    }
  }

  Future initHive() async {
    cartBox = Hive.box<CartHive>('cart');
    await getData();
    countTotalPrice();
  }

  List<CartModel> cartModels = [];

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
                      if (cartModels[index].quantity! == 1) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: Text(
                                'Apakah anda yakin ingin menghapus layanan ${cartModels[index].serviceModel!.name}?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  minusQuantity(cartModels[index], index);
                                  cartModels[index].quantity =
                                      cartModels[index].quantity! - 1;
                                  countTotalPrice();
                                  cartBox.delete(cartBox.keyAt(index));
                                  removeCart(cartModels[index]);
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        setState(() {});
                      } else {
                        minusQuantity(cartModels[index], index);
                        cartModels[index].quantity =
                            cartModels[index].quantity! - 1;
                        countTotalPrice();
                        setState(() {});
                      }
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
                        onTap: () => checkOut(),
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
          ),
          isLoad
              ? Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.white.withOpacity(0.4),
                  child: Center(
                      child: Container(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                        color: Colors.orange.shade600, strokeWidth: 3),
                  )),
                )
              : Container()
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
            child: widget.cartModel.serviceModel != null &&
                    widget.cartModel.serviceModel!.images != null &&
                    widget.cartModel.serviceModel!.images!.length != 0
                ? Container(
                    height: size.height * 0.1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      // child: CachedNetworkImage(
                      //   imageUrl: widget.cartModel.serviceModel!.images![0] != '' ? widget.cartModel.serviceModel!.images![0] : 'https://picsum.photos/64',
                      //   fit: BoxFit.cover,
                      // ),
                      child: Container(
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                            child: CustomCachedImage.build(
                          context,
                          imgUrl:
                              widget.cartModel.serviceModel!.images![0] != ''
                                  ? widget.cartModel.serviceModel!.images![0]
                                  : 'https://picsum.photos/64',
                        )),
                      ),
                    ),
                  )
                : Container(),
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
                      widget.cartModel.description != null &&
                              widget.cartModel.description != ''
                          ? widget.cartModel.description!
                          : '(Tanpa keterangan)',
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
