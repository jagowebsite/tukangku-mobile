import 'package:flutter/material.dart';
import 'package:tukangku/models/transaction_model.dart';
import 'package:tukangku/screens/account/master/transaction/master_transaction_confirmation.dart';
import 'package:tukangku/screens/account/master/user/master_user_edit.dart';
import 'package:tukangku/utils/currency_format.dart';

class MasterTransactionDetail extends StatefulWidget {
  final TransactionModel transactionModel;
  const MasterTransactionDetail({Key? key, required this.transactionModel})
      : super(key: key);

  @override
  _MasterTransactionDetailState createState() =>
      _MasterTransactionDetailState();
}

class _MasterTransactionDetailState extends State<MasterTransactionDetail> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Detail User Pembeli',
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
                      'Data Konsumen',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MasterUserEdit(
                              user: widget.transactionModel.user!);
                        }));
                      },
                      leading: Container(
                        decoration: BoxDecoration(
                            color: Colors.orange, shape: BoxShape.circle),
                        child: Container(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                widget.transactionModel.user!.images ?? ''),
                          ),
                        ),
                      ),
                      title: Container(
                        child: Text(
                          widget.transactionModel.user!.name ?? '',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      subtitle: Text(widget.transactionModel.user!.email ?? ''),
                      trailing:
                          Icon(Icons.chevron_right, color: Colors.black87),
                    )
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
                      'Konfirmasi Transaksi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    for (TransactionDetail transactionDetail
                        in widget.transactionModel.transactionDetail!)
                      ListTile(
                          title: Text(
                              '${transactionDetail.serviceModel!.name} - ${transactionDetail.serviceModel!.categoryService!.name}'),
                          subtitle: Text(
                              transactionDetail.statusOrderDetail ?? '',
                              style: TextStyle(color: Colors.orange)),
                          isThreeLine: true,
                          leading: Icon(Icons.close),
                          trailing: GestureDetector(
                            onTap: () {
                              if (transactionDetail.statusOrderDetail ==
                                  'pending') {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MasterTransactionConfirmation(
                                      transactionDetail: transactionDetail);
                                }));
                              }
                            },
                            child:
                                transactionDetail.statusOrderDetail == 'success'
                                    ? Icon(Icons.check_circle)
                                    : transactionDetail.statusOrderDetail ==
                                            'pending'
                                        ? Icon(Icons.more_horiz)
                                        : Icon(Icons.warning),
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
                        Text(widget.transactionModel.invoiceId ?? '')
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Tanggal')),
                        Text(widget.transactionModel.createdAt ?? '')
                      ],
                    ),
                    Divider(
                      thickness: 0.4,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    for (TransactionDetail transactionDetail
                        in widget.transactionModel.transactionDetail!)
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                                  (transactionDetail.serviceModel!.name ?? '') +
                                      '@${transactionDetail.quantity}')),
                          Text(currencyId.format(transactionDetail.totalPrice))
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
                          currencyId
                              .format(widget.transactionModel.totalAllPrice)
                              .toString(),
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
