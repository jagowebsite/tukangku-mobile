import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  double latitude = -7.2849593;
  double longitude = 112.6921382;
  Position? position;

  // Data for dropdown type
  List<String> typeList = ['Cash', 'Transfer'];
  String typeValue = 'Cash';

  Future _determinePosition() async {
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

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    position = await Geolocator.getCurrentPosition();
    // print(position!.latitude);
    // print(position!.longitude);
    latitude = position!.latitude;
    longitude = position!.longitude;
    setState(() {});
  }

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
      body: Column(
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
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              Colors.grey.shade100),
                                      child: Text('DP',
                                          style:
                                              TextStyle(color: Colors.black87)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              Colors.orangeAccent.shade700),
                                      child: Text('Lunas',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                              'Informasi Pembayaran',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.orangeAccent.shade700,
                                width: 1,
                              ),
                            ),
                            child: Center(
                                child: Text('+ Pilih Foto',
                                    style: TextStyle(
                                        color: Colors.orangeAccent.shade700)))),
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.orangeAccent.shade700,
                                width: 1,
                              ),
                            ),
                            child: Center(
                                child: Text('+ Upload Foto',
                                    style: TextStyle(
                                        color: Colors.orangeAccent.shade700)))),
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
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                            minLines: 3,
                            maxLines: 10,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Masukkan alamat lengkap disini...'),
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
                                        options: MapOptions(
                                            center: LatLng(latitude, longitude),
                                            zoom: 15.0,
                                            onTap: (position, latlng) {
                                              setState(() {
                                                latitude = latlng.latitude;
                                                longitude = latlng.longitude;
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
                                                point:
                                                    LatLng(latitude, longitude),
                                                builder: (ctx) => Container(
                                                    child: Icon(
                                                  Icons.place,
                                                  color: Colors.red.shade700,
                                                  size: 45,
                                                )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/map-coordinate'),
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
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                          'Rp 300.000',
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
                      onPressed: () => Navigator.pop(context),
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
    );
  }
}
