import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/transaction_bloc/transaction_bloc.dart';
import 'package:tukangku/blocs/transaction_detail_bloc/transaction_detail_bloc.dart';
import 'package:tukangku/models/payment_model.dart';
import 'package:tukangku/models/transaction_model.dart';
import 'package:tukangku/screens/account/master/transaction/master_transaction_confirmation.dart';
import 'package:tukangku/screens/account/master/user/master_user_edit.dart';
import 'package:tukangku/screens/widgets/bottom_sheet_modal.dart';
import 'package:tukangku/utils/currency_format.dart';
import 'package:tukangku/utils/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MasterTransactionDetail extends StatefulWidget {
  final TransactionModel transactionModel;
  const MasterTransactionDetail({Key? key, required this.transactionModel})
      : super(key: key);

  @override
  _MasterTransactionDetailState createState() =>
      _MasterTransactionDetailState();
}

class _MasterTransactionDetailState extends State<MasterTransactionDetail> {
  late TransactionDetailBloc transactionDetailBloc;
  late TransactionBloc transactionBloc;

  final _baseUrl = dotenv.env['API_URL'].toString();

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    transactionDetailBloc
        .add(GetTransactionDetail(widget.transactionModel.id!));
    print('Refresing...');
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    transactionDetailBloc
        .add(GetTransactionDetail(widget.transactionModel.id!));
  }

  Future confirmInfo() async {
    BottomSheetModal.show(context,
        padding: EdgeInsets.all(10),
        height: 300,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text('Detail konfirmasi transaksi'),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                'Nama Tukang',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text(
                'Handoko',
                textAlign: TextAlign.end,
              ))
            ],
          ),
          Row(
            children: [
              Text(
                'Upah',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(child: Text('Rp 100.000', textAlign: TextAlign.end))
            ],
          ),
          Row(
            children: [
              Text(
                'Jumlah/Durasi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(child: Text('1 Jam', textAlign: TextAlign.end))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deskripsi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text(
                      'Pekerjaan sangat cepat dan murah meriah indonesia sekali',
                      textAlign: TextAlign.end))
            ],
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ]);
  }

  Future confirmTransaction() async {
    BottomSheetModal.show(context, children: [
      const Text('Apakah kamu yakin ingin mengkonfirmasi transaksi?'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(primary: Colors.orangeAccent.shade700),
            child: const Text('Ya, konfirmasi',
                style: TextStyle(color: Colors.white)),
            onPressed: () {
              transactionBloc
                  .add(ConfirmTransaction(widget.transactionModel.id!));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ]);
  }

  Future cancelTransaction() async {
    BottomSheetModal.show(context, children: [
      const Text('Apakah kamu yakin ingin membatalkan transaksi?'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(primary: Colors.orangeAccent.shade700),
            child: const Text('Ya, batalkan',
                style: TextStyle(color: Colors.white)),
            onPressed: () {
              transactionBloc
                  .add(CancelTransaction(widget.transactionModel.id!));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ]);
  }

  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  void initState() {
    transactionDetailBloc = BlocProvider.of<TransactionDetailBloc>(context);
    transactionBloc = BlocProvider.of<TransactionBloc>(context);
    transactionDetailBloc
        .add(GetTransactionDetail(widget.transactionModel.id!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is ConfirmTransactionSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is ConfirmTransactionError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        } else if (state is CancelTransactionSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is CancelTransactionError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
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
          body: RefreshIndicator(
            backgroundColor: Colors.white,
            color: Colors.orangeAccent.shade700,
            displacement: 20,
            onRefresh: () => _refresh(),
            child: Stack(
              children: [
                BlocBuilder<TransactionDetailBloc, TransactionDetailState>(
                  builder: (context, state) {
                    if (state is TransactionDetailData) {
                      return SingleChildScrollView(
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return MasterUserEdit(
                                            user:
                                                widget.transactionModel.user!);
                                      }));
                                    },
                                    leading: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.orange,
                                          shape: BoxShape.circle),
                                      child: Container(
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(widget
                                                  .transactionModel
                                                  .user!
                                                  .images ??
                                              ''),
                                        ),
                                      ),
                                    ),
                                    title: Container(
                                      child: Text(
                                        state.transactionModel.user!.name ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    subtitle: Text(
                                        state.transactionModel.user!.email ??
                                            ''),
                                    trailing: Icon(Icons.chevron_right,
                                        color: Colors.black87),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  for (TransactionDetail transactionDetail
                                      in state
                                          .transactionModel.transactionDetail!)
                                    ListTile(
                                        onTap: () {
                                          if (transactionDetail
                                                  .statusOrderDetail ==
                                              'process') {
                                            confirmInfo();
                                          }
                                        },
                                        title: Text(
                                            '${transactionDetail.serviceModel!.name} - ${transactionDetail.serviceModel!.categoryService!.name}'),
                                        subtitle: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Text(
                                                  transactionDetail
                                                          .statusOrderDetail ??
                                                      '',
                                                  style: TextStyle(
                                                      color: Colors.orange)),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            transactionDetail
                                                            .statusOrderDetail ==
                                                        'process' ||
                                                    transactionDetail
                                                            .statusOrderDetail ==
                                                        'done'
                                                ? GestureDetector(
                                                    onTap: () => _launchURL(
                                                        _baseUrl +
                                                            '/transaction/get-letters/?order_detail_id=' +
                                                            transactionDetail
                                                                .id!
                                                                .toString()),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 5),
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .grey.shade200,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child:
                                                          Text('Surat Tugas'),
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                        isThreeLine: true,
                                        trailing: GestureDetector(
                                          onTap: () {
                                            if (transactionDetail
                                                    .statusOrderDetail ==
                                                'pending') {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return MasterTransactionConfirmation(
                                                    transactionDetail:
                                                        transactionDetail);
                                              })).then(onGoBack);
                                            }
                                          },
                                          child: transactionDetail
                                                          .statusOrderDetail ==
                                                      'process' ||
                                                  transactionDetail
                                                          .statusOrderDetail ==
                                                      'done'
                                              ? Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green.shade600,
                                                )
                                              : transactionDetail
                                                          .statusOrderDetail ==
                                                      'pending'
                                                  ? Icon(Icons.more_horiz)
                                                  : Icon(Icons.cancel,
                                                      color:
                                                          Colors.red.shade600),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  for (PaymentModel paymentModel
                                      in state.transactionModel.payment!)
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: ListTile(
                                          title: Text(
                                              paymentModel.paymentCode ?? ''),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  paymentModel.createdAt ?? ''),
                                              Text(paymentModel.status ?? '',
                                                  style: TextStyle(
                                                      color: Colors.orange)),
                                            ],
                                          ),
                                          // isThreeLine: true,
                                          leading: Container(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(paymentModel
                                                                .imagesPayment !=
                                                            null &&
                                                        paymentModel
                                                                .imagesPayment !=
                                                            ''
                                                    ? paymentModel
                                                        .imagesPayment!
                                                    : 'https://picsum.photos/64'),
                                              ),
                                            ),
                                          ),
                                          trailing: Icon(
                                            Icons.check_circle,
                                            color: Colors.green.shade600,
                                          )),
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
                                    'Summary',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(child: Text('Invoice')),
                                      Text(state.transactionModel.invoiceId ??
                                          '')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(child: Text('Tanggal')),
                                      Text(state.transactionModel.createdAt ??
                                          '')
                                    ],
                                  ),
                                  Divider(
                                    thickness: 0.4,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  for (TransactionDetail transactionDetail
                                      in state
                                          .transactionModel.transactionDetail!)
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text((transactionDetail
                                                        .serviceModel!.name ??
                                                    '') +
                                                '@${transactionDetail.quantity}')),
                                        Text(currencyId.format(
                                            transactionDetail.totalPrice))
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      Text(
                                        currencyId
                                            .format(state
                                                .transactionModel.totalAllPrice)
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            !(state.transactionModel.statusOrder == 'done' ||
                                    state.transactionModel.statusOrder ==
                                        'cancel')
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red.shade600),
                                          onPressed: () => cancelTransaction(),
                                          child: Text('Batalkan',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: state.transactionModel
                                                    .statusOrder ==
                                                'process'
                                            ? TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green.shade600),
                                                onPressed: () =>
                                                    confirmTransaction(),
                                                child: Text('Konfirmasi',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              )
                                            : TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey.shade600),
                                                onPressed: () {
                                                  CustomSnackbar.showSnackbar(
                                                      context,
                                                      'Silahkan lakukan konfirmasi pada masing-masing layanan',
                                                      SnackbarType.warning);
                                                },
                                                child: Text('Konfirmasi',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      );
                    } else {
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
                BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, state) {
                    if (state is ConfirmTransactionLoading ||
                        state is CancelTransactionLoading) {
                      return Container(
                          color: Colors.white.withOpacity(0.5),
                          child: Center(
                            child: Container(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.orangeAccent.shade700,
                                  strokeWidth: 3,
                                )),
                          ));
                    } else {
                      return Container();
                    }
                  },
                )
              ],
            ),
          )),
    );
  }
}
