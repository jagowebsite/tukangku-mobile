import 'package:flutter/material.dart';
import 'package:tukangku/models/transaction_model.dart';
import 'package:tukangku/screens/transaction/my_transaction_detail.dart';

class MyTransaction extends StatefulWidget {
  const MyTransaction({Key? key}) : super(key: key);

  @override
  _MyTransactionState createState() => _MyTransactionState();
}

class _MyTransactionState extends State<MyTransaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Semua Transaksi',
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
        body: ListView.separated(
          physics: AlwaysScrollableScrollPhysics(),
          // controller: _scrollController,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MyTransactionDetail();
                }));
              },
              isThreeLine: true,
              leading: Icon(Icons.receipt),
              title: Container(
                child: Text(
                  'HJKSJK667 - Haikal',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (TransactionDetail transactionDetail in [])
                    Text(transactionDetail.serviceModel!.name ?? ''),
                  Text('Layanan Bebersih'),
                  Text('Layanan Service AC'),
                ],
              ),
              trailing: Column(
                children: [
                  Text('Selesai'),
                  Icon(Icons.check_circle_outline, color: Colors.green.shade600)
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              thickness: 0.3,
            );
          },
          itemCount: 3,
        ));
  }
}
