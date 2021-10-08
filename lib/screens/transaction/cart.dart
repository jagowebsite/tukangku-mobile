import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
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
              padding: EdgeInsets.symmetric(vertical: 10),
              // shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return CartItem();
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
                        child: Center(
                          child: Text(
                            'Checkout (3)',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
  }) : super(key: key);

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
                  Text('Mengepel Semua Ruangan Rumah'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'Bebersih',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Text(
                    'Rp 100.000',
                    style: TextStyle(
                        color: Colors.orangeAccent.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.all(5),
                        color: Colors.grey.shade200,
                        child: Center(child: Text('-')),
                      ),
                      Container(
                        width: 50,
                        height: 30,
                        padding: EdgeInsets.all(5),
                        color: Colors.grey.shade100,
                        child: Center(child: Text('1')),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.all(5),
                        color: Colors.grey.shade200,
                        child: Center(child: Text('+')),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text('Per Jam'),
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
