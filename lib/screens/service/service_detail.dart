import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:readmore/readmore.dart';

class ServiceDetail extends StatefulWidget {
  const ServiceDetail({Key? key}) : super(key: key);

  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  final CarouselController _controller = CarouselController();

  // Index untuk indicator carousel
  int _currentCarrousel = 0;

  List<String> imgList = [
    'https://psdfreebies.com/wp-content/uploads/2019/01/Travel-Service-Banner-Ads-Templates-PSD.jpg',
    'https://thumbs.dreamstime.com/z/phone-repair-service-banner-template-smartphone-broken-screen-phone-repair-service-banner-template-smartphone-broken-134038666.jpg',
    'https://harjaditutoring.weebly.com/uploads/1/8/9/7/18970359/online-classes-05_orig.jpg',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/personal-online-tutor-english-instagram-design-template-e05c3f54e7f260d3718e903817cc1c9f_screen.jpg?ts=1589149599',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/personal-online-tutor-english-instagram-design-template-ac46499da9cc2c4b5f373def35a14a6b_screen.jpg?ts=1591005575',
    'https://cdn4.vectorstock.com/i/1000x1000/31/38/airport-online-service-flat-banners-vector-18313138.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                          "Rp 100.000",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent.shade700),
                        ),
                        Expanded(
                          child: Text(
                            " / per Jam",
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
                      "Instalasi Pemasangan AC",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Service AC",
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
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
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
                      items: imgList
                          .map((item) => Container(
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
                                          highlightColor: Colors.grey.shade100,
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
                          children: imgList.asMap().entries.map((entry) {
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
                              Text('Pesan Sekarang',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        )))),
          )
        ],
      ),
    );
  }
}
