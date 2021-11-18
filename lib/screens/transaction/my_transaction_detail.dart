import 'package:flutter/material.dart';
import 'package:tukangku/models/transaction_model.dart';
import 'package:tukangku/utils/currency_format.dart';

class MyTransactionDetail extends StatefulWidget {
  const MyTransactionDetail({Key? key}) : super(key: key);

  @override
  _MyTransactionDetailState createState() => _MyTransactionDetailState();
}

class _MyTransactionDetailState extends State<MyTransactionDetail> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Detail Transaksi',
              style: TextStyle(color: Colors.black87),
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ))),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3,
                          offset: Offset(0, 1))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Layanan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // for (TransactionDetail transactionDetail
                    //     in [])
                    //   ListTile(
                    //       title: Text(
                    //           'Bebersih - Layanan Rumah'),
                    //       ),
                    ListTile(
                      title: Text('Bebersih - Layanan Rumah'),
                    ),
                    ListTile(
                      title: Text('Bebersih - Layanan Rumah'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: size.width,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3,
                          offset: Offset(0, 1))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bukti Pembayaran Transaksi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
                        title: Text('4544859473'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('19 October 2021'),
                            Text('Lunas',
                                style: TextStyle(color: Colors.orange)),
                          ],
                        ),
                        // isThreeLine: true,
                        leading: Container(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network('https://picsum.photos/64'),
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                        title: Text('4544859473'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('19 October 2021'),
                            Text('Lunas',
                                style: TextStyle(color: Colors.orange)),
                          ],
                        ),
                        // isThreeLine: true,
                        leading: Container(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network('https://picsum.photos/64'),
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: size.width,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3,
                          offset: Offset(0, 1))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Summary',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Invoice')),
                        Text('IIKDJHJA3484')
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Tanggal')),
                        Text('2021-01-23')
                      ],
                    ),
                    Divider(
                      thickness: 0.4,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // for (TransactionDetail transactionDetail in [])
                    //   Row(
                    //     children: [
                    //       Expanded(
                    //           child: Text(
                    //               (transactionDetail.serviceModel!.name ?? '') +
                    //                   '@${transactionDetail.quantity}')),
                    //       Text(currencyId.format(transactionDetail.totalPrice))
                    //     ],
                    //   ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(('Bebersih - Layanan Rumah') + '@3')),
                        Text(currencyId.format(10000))
                      ],
                    ),
                    Divider(
                      thickness: 0.4,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Text(
                          currencyId.format(100000).toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red.shade600),
                      onPressed: () {},
                      child: Text('Batalkan',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.green.shade600),
                      onPressed: () {},
                      child: Text('Konfirmasi',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
