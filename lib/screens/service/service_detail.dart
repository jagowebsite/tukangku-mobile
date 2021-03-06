import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:readmore/readmore.dart';
import 'package:tukangku/hive/cart/cart_hive.dart';
import 'package:tukangku/models/service_model.dart';
import 'package:tukangku/screens/widgets/bottom_sheet_modal.dart';
import 'package:tukangku/screens/widgets/image_viewer.dart';
import 'package:tukangku/utils/currency_format.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class ServiceDetail extends StatefulWidget {
  final ServiceModel serviceModel;
  const ServiceDetail({Key? key, required this.serviceModel}) : super(key: key);

  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  final CarouselController _controller = CarouselController();
  TextEditingController descriptionController = TextEditingController();
  late Box cartBox;
  int totalService = 0;

  // Index untuk indicator carousel
  int _currentCarrousel = 0;

  Future addData(int id) async {
    // var cartBox = await Hive.openBox<CartHive>('cart');
    // id = 3;
    bool isNew = true;
    for (var i = 0; i < cartBox.length; i++) {
      CartHive cartHive = cartBox.getAt(i);
      if (cartHive.serviceId == id) {
        isNew = false;

        CartHive updateCartHive = CartHive()
          ..description = descriptionController.text
          ..quantity = (cartHive.quantity + 1)
          ..serviceId = cartHive.serviceId;
        cartBox.put(cartBox.keyAt(i), updateCartHive);
      }
    }

    if (isNew) {
      CartHive cartHive = CartHive()
        ..quantity = 1
        ..description = descriptionController.text
        ..serviceId = id;
      cartBox.add(cartHive);
    }

    CustomSnackbar.showSnackbar(
        context, 'Berhasil ditambahkan ke keranjang', SnackbarType.success,
        snackBarAction: SnackBarAction(
            textColor: Colors.white,
            label: 'Lihat Keranjang',
            onPressed: () => Navigator.of(context).pushNamed('/cart')));
  }

  Future addToCart(int id) async {
    BottomSheetModal.show(context,
        padding: EdgeInsets.all(10),
        height: 200,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('Silahkan masukkan jumlah layanan yang ingin dipesan'),
              SizedBox(
                height: 10,
              ),
              // Row(
              //   children: [
              //     Expanded(child: Text('Jumlah Layanan')),
              //     SizedBox(
              //       height: 10,
              //     ),
              //     Row(
              //       children: [
              //         GestureDetector(
              //           onTap: (){
              //             if(totalService > 0){
              //               totalService = totalService - 1;
              //               setState(() {

              //               });
              //             }
              //           },
              //           child: Container(
              //             width: 30,
              //             height: 30,
              //             padding: EdgeInsets.all(5),
              //             color: Colors.grey.shade200,
              //             child: Center(child: Text('-')),
              //           ),
              //         ),
              //         Container(
              //           width: 50,
              //           height: 30,
              //           padding: EdgeInsets.all(5),
              //           color: Colors.grey.shade100,
              //           child: Center(child: Text(totalService.toString())),
              //         ),
              //         GestureDetector(
              //           onTap: (){
              //             totalService = totalService + 1;
              //             setState(() {

              //             });
              //           },
              //           child: Container(
              //             width: 30,
              //             height: 30,
              //             padding: EdgeInsets.all(5),
              //             color: Colors.grey.shade200,
              //             child: Center(child: Text('+')),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              Text('Deskripsi (opsional)'),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade100),
                child: TextField(
                  controller: descriptionController,
                  textInputAction: TextInputAction.done,
                  minLines: 3,
                  maxLines: 10,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Masukkan deskripsi tambahan disini...'),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                    child: const Text(
                      'Batal',
                      style: TextStyle(color: Colors.black87),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.orangeAccent.shade700),
                    child: const Text('Tambah ke Keranjang',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      addData(id);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ]);
  }

  List<CartHive>? listCarts;

  Future getData() async {
    // cartBox.put(2, cartHive2);
    // print(cartBox.keyAt(i));
    listCarts = cartBox.values.toList().cast<CartHive>();
  }

  Future initHive() async {
    cartBox = Hive.box<CartHive>('cart');
    getData();
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
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SlidingUpPanel(
            minHeight: size.height * 0.55,
            maxHeight: size.height * 0.55,
            parallaxEnabled: true,
            parallaxOffset: .5,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            panelBuilder: (controller) {
              return SingleChildScrollView(
                controller: controller,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Center(
                        child: Container(
                          height: 5,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          widget.serviceModel.price != null
                              ? currencyId
                                  .format(widget.serviceModel.price)
                                  .toString()
                              : 'Rp 0',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent.shade700),
                        ),
                        Expanded(
                          child: Text(
                            " / per ${widget.serviceModel.typeQuantity}",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.serviceModel.name ?? '',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.serviceModel.categoryService!.name ?? '',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Deskripsi",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ReadMoreText(
                      widget.serviceModel.description ?? '',
                      trimLines: 3,
                      style: TextStyle(color: Colors.grey),
                      colorClickableText: Colors.pink,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      delimiter: '\n',
                      lessStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade700,
                      ),
                      moreStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    )
                  ],
                ),
              );
            },
            body: Container(
              height: size.height * 0.3,
              child: Stack(
                children: [
                  Container(
                    height: size.height * 0.5,
                    width: size.width,
                    child: CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 1,
                          viewportFraction: 1.0,
                          disableCenter: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentCarrousel = index;
                            });
                          }
                          // enlargeCenterPage: true,
                          ),
                      items: (widget.serviceModel.images ?? [])
                          .map((item) => GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ImageViewer(
                                      imageURL: item,
                                    );
                                  }));
                                },
                                child: Container(
                                  width: size.width,
                                  child: CachedNetworkImage(
                                    imageUrl: item,
                                    fit: BoxFit.cover,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor:
                                                Colors.grey.shade100,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: Icon(Icons.image,
                                                    size: 100))),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.grey.shade100,
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Shimmer.fromColors(
                                          baseColor: Colors.grey.shade200,
                                          highlightColor: Colors.grey.shade100,
                                          child: Icon(Icons.error)),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  Positioned(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SafeArea(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withOpacity(0.8)),
                            child: Icon(Icons.chevron_left, size: 30),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: size.height * 0.4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: (widget.serviceModel.images ?? [])
                              .asMap()
                              .entries
                              .map((entry) {
                            return GestureDetector(
                              onTap: () => _controller.animateToPage(entry.key),
                              child: Container(
                                width: 12.0,
                                height: 12.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black)
                                        .withOpacity(
                                            _currentCarrousel == entry.key
                                                ? 0.9
                                                : 0.4)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  // onTap: () => Navigator.of(context).pushNamed('/cart'),
                  // onTap: () => addData(widget.serviceModel.id!),
                  onTap: () => addToCart(widget.serviceModel.id!),
                  child: Container(
                      color: Colors.white,
                      child: Container(
                          margin: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent.shade700,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Tambah ke Keranjang',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ))),
                )),
          )
        ],
      ),
    );
  }
}
