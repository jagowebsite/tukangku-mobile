import 'package:flutter/material.dart';

class MasterPayment extends StatefulWidget {
  const MasterPayment({Key? key}) : super(key: key);

  @override
  _MasterPaymentState createState() => _MasterPaymentState();
}

class _MasterPaymentState extends State<MasterPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Transaksi Pembeli',
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
    );
  }
}
