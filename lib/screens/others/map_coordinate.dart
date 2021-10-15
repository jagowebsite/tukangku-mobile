import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapCoordinate extends StatefulWidget {
  const MapCoordinate({Key? key}) : super(key: key);

  @override
  _MapCoordinateState createState() => _MapCoordinateState();
}

class _MapCoordinateState extends State<MapCoordinate> {
  double latitude = -7.2849593;
  double longitude = 112.6921382;
  Position? position;

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
        title: Text(
          'Koordinat Lokasi',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.black87)),
        actions: [
          IconButton(
              onPressed: () => _determinePosition(),
              icon: Icon(Icons.place, color: Colors.black87))
        ],
      ),
      body: Stack(
        children: [
          position != null
              ? FlutterMap(
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
                          point: LatLng(latitude, longitude),
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
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: size.width,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                // color: Colors.green.shade600,
                child: TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: Colors.green.shade600),
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pilih Lokasi',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white)
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
