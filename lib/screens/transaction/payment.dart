import 'dart:io';

// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tukangku/blocs/payment_bloc/payment_bloc.dart';
import 'package:tukangku/models/location_model.dart';
import 'package:tukangku/models/payment_model.dart';
import 'package:tukangku/models/transaction_model.dart';
import 'package:tukangku/screens/others/map_coordinate.dart';
// import 'package:tukangku/screens/widgets/camera_screen.dart';
// import 'package:tukangku/screens/widgets/camera_screen2.dart';
import 'package:tukangku/utils/currency_format.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

// Jenis pembayaran (dp | lunas)
enum PaymentFlow { dp, paid }

class Payment extends StatefulWidget {
  final TransactionModel transactionModel;
  const Payment({Key? key, required this.transactionModel}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  MapController mapController = MapController();
  late PaymentBloc paymentBloc;
  LocationModel locationModel =
      LocationModel(latitude: -7.2849593, longitude: 112.6921382);
  Position? position;
  File? imagePaymentFile;
  File? imageUserFile;
  bool isLocationChoosen = false;

  TextEditingController bankNameController = TextEditingController();
  TextEditingController noRekController = TextEditingController();
  TextEditingController rekNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nominalDPController = TextEditingController();

  PaymentFlow paymentFlow = PaymentFlow.paid;

  // Data for dropdown type
  List<String> typeList = ['Cash', 'Transfer'];
  String typeValue = 'Cash';

  Future _determinePosition({bool isCurrent = false}) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        CustomSnackbar.showSnackbar(
            context,
            'Silahkan nyalakan lokasi anda sebelum melakukan pembayaran',
            SnackbarType.warning);
        Navigator.pop(context);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
      CustomSnackbar.showSnackbar(
          context,
          'Silahkan nyalakan lokasi anda sebelum melakukan pembayaran',
          SnackbarType.warning);
      Navigator.pop(context);
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    position = await Geolocator.getCurrentPosition();
    if (isCurrent) {
      locationModel.longitude = position!.longitude;
      locationModel.latitude = position!.latitude;
    }

    setState(() {});
  }

  Future pickImagePayment() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePaymentFile = File(image.path);
      setState(() {});
    }
  }

  Future pickImageUser() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      imageUserFile = File(image.path);
      setState(() {});
    }
  }

  Future createPayment() async {
    if (noRekController.text == '' ||
        bankNameController.text == '' ||
        rekNameController.text == '' ||
        addressController.text == '') {
      CustomSnackbar.showSnackbar(context,
          'Mohon lengkapi informasi pembayaran anda', SnackbarType.warning);
    } else if (imagePaymentFile == null) {
      CustomSnackbar.showSnackbar(
          context,
          'Silahkan upload bukti pembayaran terlebih dahulu',
          SnackbarType.warning);
    } else if (imageUserFile == null) {
      CustomSnackbar.showSnackbar(
          context,
          'Silahkan upload foto anda beserta KTP terlebih dahulu',
          SnackbarType.warning);
    } else if (!isLocationChoosen) {
      CustomSnackbar.showSnackbar(
          context,
          'Silahkan pilih koordinat lokasi anda terlebih dahulu',
          SnackbarType.warning);
    } else if (paymentFlow == PaymentFlow.dp &&
        int.parse(nominalDPController.text) >
            widget.transactionModel.totalAllPrice!) {
      CustomSnackbar.showSnackbar(
          context,
          'Nominal DP tidak boleh lebih dari total pembayaran sebesar ${widget.transactionModel.totalAllPrice}',
          SnackbarType.warning);
    } else {
      PaymentModel paymentModel = PaymentModel(
          transactionModel: widget.transactionModel,
          typeTransfer: typeValue.toLowerCase(),
          type: paymentFlow == PaymentFlow.dp ? 'dp' : 'lunas',
          bankNumber: noRekController.text,
          bankName: bankNameController.text,
          accountName: rekNameController.text,
          latitude: locationModel.latitude.toString(),
          longitude: locationModel.longitude.toString(),
          totalPayment: paymentFlow == PaymentFlow.dp
              ? int.parse(nominalDPController.text)
              : widget.transactionModel.totalAllPrice,
          description: descriptionController.text,
          address: addressController.text,
          imagePaymentFile: imagePaymentFile,
          imageUserFile: imageUserFile);

      paymentBloc.add(CreatePayment(paymentModel));
    }
  }

  @override
  void initState() {
    paymentBloc = BlocProvider.of<PaymentBloc>(context);
    _determinePosition(isCurrent: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is CreatePaymentSuccess) {
          CustomSnackbar.showSnackbar(
              context,
              '${state.message}, Mohon menunggu konfirmasi dari Tukangkita',
              SnackbarType.success);
          Navigator.pop(context);
        } else if (state is CreatePaymentError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Payment',
            style: TextStyle(color: Colors.black87),
          ),
          elevation: 0.5,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.grey.shade100,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.white,
                          width: size.width,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Jenis Pembayaran',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Tipe Bayar'),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade100),
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.grey.shade100,
                                  value: typeValue,
                                  isExpanded: true,
                                  icon: Icon(Icons.expand_more),
                                  iconSize: 24,
                                  elevation: 1,
                                  style: TextStyle(color: Colors.black),
                                  underline: Container(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      typeValue = newValue!;
                                    });
                                  },
                                  items: typeList.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Jenis'),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Text('Pilih jenis pembayaran'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                paymentFlow = PaymentFlow.dp;
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                                backgroundColor: paymentFlow ==
                                                        PaymentFlow.dp
                                                    ? Colors
                                                        .orangeAccent.shade700
                                                    : Colors.grey.shade100),
                                            child: Text('DP',
                                                style: TextStyle(
                                                    color: paymentFlow ==
                                                            PaymentFlow.dp
                                                        ? Colors.white
                                                        : Colors.black87)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                paymentFlow = PaymentFlow.paid;
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                                backgroundColor: paymentFlow ==
                                                        PaymentFlow.paid
                                                    ? Colors
                                                        .orangeAccent.shade700
                                                    : Colors.grey.shade100),
                                            child: Text('Lunas',
                                                style: TextStyle(
                                                    color: paymentFlow ==
                                                            PaymentFlow.paid
                                                        ? Colors.white
                                                        : Colors.black87)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              paymentFlow == PaymentFlow.dp
                                  ? Text('Nominal DP (RP)')
                                  : Container(),
                              paymentFlow == PaymentFlow.dp
                                  ? Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey.shade100),
                                      child: TextField(
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        controller: nominalDPController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.white,
                          width: size.width,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Informasi Pembayaran',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Nama Bank'),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade100),
                                child: TextField(
                                  controller: bankNameController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Contoh: BCA, BRI, dll.'),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Nomor Rekening'),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade100),
                                child: TextField(
                                  controller: noRekController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Nomor Rekening Bank'),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Nama Rekening'),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade100),
                                child: TextField(
                                  controller: rekNameController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Masukkan nama rekening kamu'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.white,
                          width: size.width,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Bukti Pembayaran',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () => pickImagePayment(),
                                child: Container(
                                    width: size.width,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.orangeAccent.shade700,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                        child: imagePaymentFile == null
                                            ? Text('+ Pilih Foto',
                                                style: TextStyle(
                                                    color: Colors
                                                        .orangeAccent.shade700))
                                            : Container(
                                                child: Image.file(
                                                    imagePaymentFile!),
                                              ))),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.white,
                          width: size.width,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Foto Kamu',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await pickImageUser();
                                  // await availableCameras().then((value) async {
                                  //   imageUserFile = await Navigator.push<File>(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (_) => CameraScreen(
                                  //                 cameras: value,
                                  //               )));
                                  // });

                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: (context) {
                                  //   return CameraScreen2();
                                  // }));

                                  setState(() {});
                                },
                                child: Container(
                                    width: size.width,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.orangeAccent.shade700,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                        child: imageUserFile == null
                                            ? Text('+ Pilih Foto',
                                                style: TextStyle(
                                                    color: Colors
                                                        .orangeAccent.shade700))
                                            : Container(
                                                child:
                                                    Image.file(imageUserFile!),
                                              ))),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Lokasi Rumah',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Alamat Lengkap'),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade100),
                                child: TextField(
                                  controller: addressController,
                                  minLines: 3,
                                  maxLines: 10,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText:
                                          'Masukkan alamat lengkap disini...'),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Pilih Koordinat Lokasi'),
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15)),
                                child: position != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Stack(
                                          children: [
                                            FlutterMap(
                                              mapController: mapController,
                                              options: MapOptions(
                                                  center: LatLng(
                                                      locationModel.latitude,
                                                      locationModel.longitude),
                                                  zoom: 15.0,
                                                  onTap: (position, latlng) {
                                                    setState(() {
                                                      locationModel.latitude =
                                                          latlng.latitude;
                                                      locationModel.longitude =
                                                          latlng.longitude;
                                                    });
                                                    print(latlng.latitude);
                                                  }),
                                              layers: [
                                                TileLayerOptions(
                                                  urlTemplate:
                                                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                                  subdomains: ['a', 'b', 'c'],
                                                  // attributionBuilder: (_) {
                                                  //   return Text("© OpenStreetMap contributors");
                                                  // },
                                                ),
                                                MarkerLayerOptions(
                                                  markers: [
                                                    Marker(
                                                      width: 80.0,
                                                      height: 80.0,
                                                      point: LatLng(
                                                          locationModel
                                                              .latitude,
                                                          locationModel
                                                              .longitude),
                                                      builder: (ctx) =>
                                                          Container(
                                                              child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.place,
                                                            color: Colors
                                                                .red.shade700,
                                                            size: 45,
                                                          ),
                                                          Container(
                                                            width: 27,
                                                            height: 5,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .all(
                                                                        Radius.elliptical(
                                                                            100,
                                                                            50)),
                                                                // borderRadius: BorderRadius.circular(50),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.5),
                                                                      offset:
                                                                          Offset(0,
                                                                              0),
                                                                      blurRadius:
                                                                          3,
                                                                      spreadRadius:
                                                                          0)
                                                                ]),
                                                          )
                                                        ],
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                final location = await Navigator.push<
                                                        LocationModel>(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            MapCoordinate(
                                                                locationModel:
                                                                    locationModel)));
                                                if (location != null) {
                                                  locationModel = location;
                                                  isLocationChoosen = true;
                                                  // await _determinePosition();
                                                  mapController.move(
                                                      LatLng(
                                                          locationModel
                                                              .latitude,
                                                          locationModel
                                                              .longitude),
                                                      15.0);
                                                  print(locationModel.latitude);
                                                  print(
                                                      locationModel.longitude);
                                                  setState(() {});
                                                }
                                              },
                                              child: Container(
                                                height: double.infinity,
                                                width: double.infinity,
                                                color: Colors.transparent,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Lainnya',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Deskripsi (opsional)'),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade100),
                                child: TextField(
                                  controller: descriptionController,
                                  minLines: 3,
                                  maxLines: 10,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText:
                                          'Masukkan deskripsi tambahan disini...'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                          child: Wrap(
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                currencyId
                                    .format(paymentFlow == PaymentFlow.dp
                                        ? int.parse(
                                            nominalDPController.text != ''
                                                ? nominalDPController.text
                                                : '0')
                                        : widget.transactionModel.totalAllPrice)
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.orangeAccent.shade700,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.orangeAccent.shade700,
                          child: TextButton(
                            onPressed: () => createPayment(),
                            child: Text('Lanjutkan',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            BlocBuilder<PaymentBloc, PaymentState>(
              builder: (context, state) {
                if (state is CreatePaymentLoading) {
                  return Container(
                      color: Colors.white.withOpacity(0.5),
                      child: Center(
                        child: Container(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              color: Colors.orangeAccent.shade700,
                              strokeWidth: 3,
                            )),
                      ));
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
