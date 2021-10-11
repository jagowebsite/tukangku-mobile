import 'package:flutter/material.dart';

class MasterTransaction extends StatefulWidget {
  const MasterTransaction({Key? key}) : super(key: key);

  @override
  _MasterTransactionState createState() => _MasterTransactionState();
}

class _MasterTransactionState extends State<MasterTransaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'View User Pembeli',
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
