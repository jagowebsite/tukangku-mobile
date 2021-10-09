import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Design extends StatefulWidget {
  const Design({Key? key}) : super(key: key);

  @override
  _DesignState createState() => _DesignState();
}

class _DesignState extends State<Design> {
  List<String> imgService = [
    'https://psdfreebies.com/wp-content/uploads/2019/01/Travel-Service-Banner-Ads-Templates-PSD.jpg',
    'https://thumbs.dreamstime.com/z/phone-repair-service-banner-template-smartphone-broken-screen-phone-repair-service-banner-template-smartphone-broken-134038666.jpg',
    'https://harjaditutoring.weebly.com/uploads/1/8/9/7/18970359/online-classes-05_orig.jpg',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/personal-online-tutor-english-instagram-design-template-e05c3f54e7f260d3718e903817cc1c9f_screen.jpg?ts=1589149599',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/personal-online-tutor-english-instagram-design-template-ac46499da9cc2c4b5f373def35a14a6b_screen.jpg?ts=1591005575',
    'https://cdn4.vectorstock.com/i/1000x1000/31/38/airport-online-service-flat-banners-vector-18313138.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Column(
          children: [
            Text(
              'Desain',
              style: TextStyle(color: Colors.black87),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed('/search'),
              child: Container(
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
                            contentPadding: EdgeInsets.only(top: 6, bottom: 11),
                            hintText: 'Cari desain yang kamu butuhkan sekarang',
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
          ],
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.all(10),
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
                  onTap: () =>
                      Navigator.of(context).pushNamed('/service-detail'),
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
      ),
    );
  }
}
