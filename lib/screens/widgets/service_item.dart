import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tukangku/models/service_model.dart';
import 'package:tukangku/screens/service/service_detail.dart';

class ServiceItem extends StatelessWidget {
  final ServiceModel serviceModel;
  final Function()? onTap;
  const ServiceItem({required this.serviceModel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 0,
        child: GestureDetector(
          onTap: () =>
              onTap ??
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ServiceDetail(serviceModel: serviceModel);
              })),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: serviceModel.images!.length != 0
                          ? serviceModel.images![0]
                          : 'https://psdfreebies.com/wp-content/uploads/2019/01/Travel-Service-Banner-Ads-Templates-PSD.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 0, 0.7, 1],
                    ),
                  ),
                ),
                Positioned(
                    child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      serviceModel.name ?? 'Service Layanan TukangKita',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
