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
        body: Container(
          child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {},
                  title: Container(
                    child: Text(
                      'TF26384529 - Haikal Rahmad Dermawan',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  isThreeLine: true,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Rp 100.000'),
                          Text(
                            ' - Lunas',
                          ),
                        ],
                      ),
                      Text(
                        'Terkonfirmasi',
                        style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right, color: Colors.black87),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 0.3,
                );
              },
              itemCount: 3),
        ));
  }
}
