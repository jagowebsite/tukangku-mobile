import 'package:flutter/material.dart';

class MasterGPSLog extends StatefulWidget {
  const MasterGPSLog({Key? key}) : super(key: key);

  @override
  _MasterGPSLogState createState() => _MasterGPSLogState();
}

class _MasterGPSLogState extends State<MasterGPSLog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Log GPS Pembeli',
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
