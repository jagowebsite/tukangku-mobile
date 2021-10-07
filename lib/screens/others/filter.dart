import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Filter Layanan',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'Kategori',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Wrap(
                  children: [
                    for (int i in [0, 1, 3, 4, 5, 6])
                      Container(
                        margin: EdgeInsets.only(right: 10, bottom: 10),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100),
                        child: Text('Bebersih $i'),
                      )
                  ],
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'Durasi Pekerjaan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Wrap(
                  children: [
                    for (int i in [0, 1, 3, 4, 5, 6])
                      Container(
                        margin: EdgeInsets.only(right: 10, bottom: 10),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100),
                        child: Text('$i Jam'),
                      )
                  ],
                )
              ],
            ),
          ),
          Positioned(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    color: Colors.white,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.orangeAccent.shade700),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text('Atur Ulang',
                                      style: TextStyle(
                                        color: Colors.orangeAccent.shade700,
                                        fontSize: 18,
                                      )),
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.orangeAccent.shade700,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text('Pakai',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      )),
                                )),
                          ),
                        ],
                      ),
                    ))),
          )
        ],
      ),
    );
  }
}
