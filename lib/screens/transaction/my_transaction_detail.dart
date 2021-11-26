import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/transaction_user_bloc/transaction_user_bloc.dart';
import 'package:tukangku/models/payment_model.dart';
import 'package:tukangku/models/transaction_model.dart';
import 'package:tukangku/utils/currency_format.dart';

class MyTransactionDetail extends StatefulWidget {
  final TransactionModel transactionModel;
  const MyTransactionDetail({Key? key, required this.transactionModel})
      : super(key: key);

  @override
  _MyTransactionDetailState createState() => _MyTransactionDetailState();
}

class _MyTransactionDetailState extends State<MyTransactionDetail> {
  late TransactionUserBloc transactionUserBloc;

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    transactionUserBloc
        .add(GetTransactionDetailUser(widget.transactionModel.id!));
    print('Refresing...');
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    transactionUserBloc
        .add(GetTransactionDetailUser(widget.transactionModel.id!));
  }

  @override
  void initState() {
    transactionUserBloc = BlocProvider.of<TransactionUserBloc>(context);
    transactionUserBloc
        .add(GetTransactionDetailUser(widget.transactionModel.id!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Detail Transaksiku',
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
        body: RefreshIndicator(
            backgroundColor: Colors.white,
            color: Colors.orangeAccent.shade700,
            displacement: 20,
            onRefresh: () => _refresh(),
          child: BlocBuilder<TransactionUserBloc, TransactionUserState>(
            builder: (context, state) {
              if(state is TransactionDetailUserData){

                return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
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
                            for (TransactionDetail transactionDetail
                                in state.transactionModel.transactionDetail!)
                              ListTile(
                                  title: Text(
                                      '${transactionDetail.serviceModel!.categoryService!.name} - ${transactionDetail.serviceModel!.name}'),
                              subtitle: Text(transactionDetail.description!),
                                  ),
                            // ListTile(
                            //   title: Text(
                            //       'Bebersih - Membersihkan Lantai Rumah (Ngepel)'),
                            //   subtitle: Text('Bebersih'),
                            // ),
                            // ListTile(
                            //   title:
                            //       Text('Service AC - 	Service AC Cepat 100% Puas'),
                            //   subtitle: Text('Service AC'),
                            // ),
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
                                Expanded(child: Text('Status')),
                                Text(
                                  state.transactionModel.statusOrder ?? '',
                                  style: TextStyle(color: Colors.green),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(child: Text('Invoice')),
                                Text(state.transactionModel.invoiceId ?? '')
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(child: Text('Tanggal')),
                                Text(state.transactionModel.createdAt ?? '')
                              ],
                            ),
                            Divider(
                              thickness: 0.4,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            for (TransactionDetail transactionDetail in state.transactionModel.transactionDetail!)
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
                                  currencyId.format(state.transactionModel.totalAllPrice).toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),

                            state.transactionModel.statusOrder == 'success' ? Center(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.grey.shade600),
                                onPressed: () {},
                                child: Text('Cetak Invoice',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ) : Container(),
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
                            for(PaymentModel paymentModel in state.transactionModel.payment!)
                              Container(
                                margin: EdgeInsets.only(bottom:10),
                                child: ListTile(
                                    title: Text(paymentModel.paymentCode ?? ''),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(paymentModel.createdAt ?? ''),
                                        Text(paymentModel.status ?? '',
                                            style: TextStyle(color: Colors.orange)),
                                      ],
                                    ),
                                    // isThreeLine: true,
                                    leading: Container(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.15,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child:
                                              Image.network('https://picsum.photos/64'),
                                        ),
                                      ),
                                    ),
                                    trailing: Icon(
                                      paymentModel.status! == 'success' ? Icons.check_circle : Icons.timer,
                                      color: Colors.green.shade600,
                                    )),
                              ),
                            Divider(),
                            Center(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.grey.shade600),
                                onPressed: () =>
                                    Navigator.of(context).pushNamed('/payment'),
                                child: Text('Tambah Pembayaran',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                );
              }else{
                return Center(
                            child: Container(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                              color: Colors.orange.shade600, strokeWidth: 3),
                        ));
              }
            },
          ),
        ));
  }
}
