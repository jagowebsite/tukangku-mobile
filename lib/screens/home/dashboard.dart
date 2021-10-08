import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<String> imgList = [
    'https://1.bp.blogspot.com/-pXvN7Ec8zA8/XVWjOqWiwyI/AAAAAAAABLU/6iVTf2gXt-AnPvdUvzRBuUl5gVr8KZMOwCLcBGAs/s640/jasa-perawat-home-care-terbaik-di-indonesia.jpg',
    'https://medi-call.id/img/content/slider/Banner%20HCC%203%20Medi-Call-01.jpg',
    'https://assets.klikindomaret.com///products/promopage/TNC%20Promosi%20Homecare.jpg',
    'https://assets.klikindomaret.com///products/promopage/TNC%20Promosi%20Homecare.jpg',
    'https://assets.klikindomaret.com///products/promopage/TNC%20Promosi%20Homecare.jpg',
  ];

  List<String> imgCategory = [
    'https://image.flaticon.com/icons/png/512/479/479358.png',
    'https://cdn-icons-png.flaticon.com/512/2575/2575842.png',
    'https://image.flaticon.com/icons/png/512/1253/1253655.png',
    'https://image.flaticon.com/icons/png/512/479/479358.png',
    'https://cdn-icons-png.flaticon.com/512/2575/2575842.png',
    'https://image.flaticon.com/icons/png/512/1253/1253655.png',
  ];

  List<String> imgService = [
    'https://psdfreebies.com/wp-content/uploads/2019/01/Travel-Service-Banner-Ads-Templates-PSD.jpg',
    'https://thumbs.dreamstime.com/z/phone-repair-service-banner-template-smartphone-broken-screen-phone-repair-service-banner-template-smartphone-broken-134038666.jpg',
    'https://harjaditutoring.weebly.com/uploads/1/8/9/7/18970359/online-classes-05_orig.jpg',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/personal-online-tutor-english-instagram-design-template-e05c3f54e7f260d3718e903817cc1c9f_screen.jpg?ts=1589149599',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/personal-online-tutor-english-instagram-design-template-ac46499da9cc2c4b5f373def35a14a6b_screen.jpg?ts=1591005575',
    'https://cdn4.vectorstock.com/i/1000x1000/31/38/airport-online-service-flat-banners-vector-18313138.jpg',
  ];

  List<String> textCategory = [
    'Bebersih',
    'Service',
    'Pertukangan',
    'Barang',
    'Desain',
    'Lainnya'
  ];

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    print('Refresing...');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat pagi,',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
            Text(
              'Boy William',
              style: TextStyle(color: Colors.black87, fontSize: 16),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/cart'),
            icon: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 3),
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.grey.shade400,
                    size: 30,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.circle,
                    color: Colors.orangeAccent.shade700,
                    size: 15,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.orangeAccent.shade700,
        displacement: 20,
        onRefresh: () => _refresh(),
        child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                  width: size.width,
                  height: size.height * 0.2,
                  margin: EdgeInsets.only(top: 10),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                    ),
                    items: imgList
                        .map((item) => Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              child: CachedNetworkImage(
                                imageUrl: item,
                                fit: BoxFit.cover,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
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
                                                    BorderRadius.circular(10)),
                                            width: double.infinity,
                                            height: double.infinity,
                                            child:
                                                Icon(Icons.image, size: 100))),
                                errorWidget: (context, url, error) => Container(
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
                )
              ])),
              SliverList(
                  delegate: SliverChildListDelegate([
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/search'),
                  child: Container(
                      margin: EdgeInsets.only(top: 20, left: 15, right: 15),
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Expanded(
                          child: TextField(
                            textAlignVertical: TextAlignVertical.bottom,
                            maxLines: 1,
                            decoration: InputDecoration(
                                isDense: true,
                                enabled: false,
                                contentPadding:
                                    EdgeInsets.only(top: 6, bottom: 11),
                                hintText:
                                    'Cari layanan yang kamu butuhkan sekarang',
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade400, fontSize: 14),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 25,
                                  color: Colors.grey,
                                )),
                          ),
                        ),
                      ])),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Text('Kategori Layanan',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700))),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 100,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      padding: EdgeInsets.all(15),
                      scrollDirection: Axis.horizontal,
                      itemCount: imgCategory.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(right: 15),
                          child: Column(
                            children: [
                              ClipOval(
                                child: Container(
                                  height: 40,
                                  color: Colors.orangeAccent,
                                  child: CachedNetworkImage(
                                    imageUrl: imgCategory[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(textCategory[index])
                            ],
                          ),
                        );
                      }),
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Text('Semua Layanan',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700))),
                Container(
                  margin: EdgeInsets.all(15),
                  child: GridView.count(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 1 / 1.3,
                    crossAxisCount: 2,
                    children: List.generate(imgService.length, (index) {
                      return Container(
                        child: Card(
                          elevation: 0,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushNamed('/service-detail'),
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
                                        imageUrl: imgService[index],
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
                                        'Service AC Rumah',
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
                    }),
                  ),
                )
              ])),
            ]),
      ),
    );
  }
}
