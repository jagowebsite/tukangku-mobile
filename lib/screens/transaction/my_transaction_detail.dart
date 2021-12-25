import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tukangku/blocs/transaction_user_bloc/transaction_user_bloc.dart';
import 'package:tukangku/models/complain_model.dart';
import 'package:tukangku/models/payment_model.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/transaction_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/complain_repository.dart';
import 'package:tukangku/screens/transaction/payment.dart';
import 'package:tukangku/screens/transaction/payment_detail.dart';
import 'package:tukangku/screens/widgets/custom_cached_image.dart';
import 'package:tukangku/utils/currency_format.dart';
import 'package:tukangku/utils/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyTransactionDetail extends StatefulWidget {
  final TransactionModel transactionModel;
  const MyTransactionDetail({Key? key, required this.transactionModel})
      : super(key: key);

  @override
  _MyTransactionDetailState createState() => _MyTransactionDetailState();
}

class _MyTransactionDetailState extends State<MyTransactionDetail> {
  late TransactionUserBloc transactionUserBloc;
  String baseUrl = dotenv.env['API_URL'].toString();
  ComplainRepository complainRepo = ComplainRepository();
  AuthRepository authRepo = AuthRepository();

  List<ComplainModel> listComplainsUser = [];

  TextEditingController complainController = TextEditingController();

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

  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  Future sendComplain(int orderId) async {
    EasyLoading.show(status: 'loading...', dismissOnTap: true);
    ComplainModel complainModel =
        ComplainModel(orderId: orderId, description: complainController.text);

    try {
      String? _token = await authRepo.hasToken();
      ResponseModel? response =
          await complainRepo.createComplain(_token!, complainModel);

      if (response != null) {
        if (response.status == 'success') {
          CustomSnackbar.showSnackbar(
              context, response.message!, SnackbarType.success);
          getComplainUser();
        } else {
          CustomSnackbar.showSnackbar(
              context, response.message!, SnackbarType.error);
        }
      } else {
        CustomSnackbar.showSnackbar(
            context,
            'Silahkan periksa kembali koneksi internet anda',
            SnackbarType.warning);
      }
    } catch (e) {
      print(e.toString());
    }
    EasyLoading.dismiss();
  }

  Future getComplainUser() async {
    String? _token = await authRepo.hasToken();
    List<ComplainModel>? listComplain = await complainRepo.getComplainUser(
        _token!, widget.transactionModel.id!);
    if (listComplain != null) {
      listComplainsUser = listComplain;
      setState(() {});
    }
  }

  @override
  void initState() {
    transactionUserBloc = BlocProvider.of<TransactionUserBloc>(context);
    transactionUserBloc
        .add(GetTransactionDetailUser(widget.transactionModel.id!));

    getComplainUser();
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
              if (state is TransactionDetailUserData) {
                int dp = 0;
                if (state.transactionModel.payment != null &&
                    state.transactionModel.payment!.isNotEmpty) {
                  for (var i = 0;
                      i < state.transactionModel.payment!.length;
                      i++) {
                    if (state.transactionModel.payment![i].status != 'reject') {
                      dp += state.transactionModel.payment![i].totalPayment!;
                    }
                  }
                }
                print(dp);
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
                                subtitle: Text(transactionDetail.description ??
                                    '(Tanpa keterangan)'),
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Expanded(child: Text('Status')),
                                Text(
                                  state.transactionModel.statusOrder!
                                      .toUpperCase(),
                                  style: state.transactionModel.statusOrder ==
                                          'done'
                                      ? TextStyle(color: Colors.green)
                                      : state.transactionModel.statusOrder ==
                                              'cancel'
                                          ? TextStyle(
                                              color: Colors.red.shade700)
                                          : TextStyle(color: Colors.orange),
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
                            for (TransactionDetail transactionDetail
                                in state.transactionModel.transactionDetail!)
                              Row(
                                children: [
                                  Expanded(
                                      child: Text((transactionDetail
                                                  .serviceModel!.name ??
                                              '') +
                                          '@${transactionDetail.quantity}')),
                                  Text(currencyId
                                      .format(transactionDetail.totalPrice))
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
                                      .format(
                                          state.transactionModel.totalAllPrice)
                                      .toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey.shade600),
                              onPressed: () => _launchURL(
                                  '$baseUrl/transaction/get-invoice/${state.transactionModel.id}'),
                              child: Text('Cetak Invoice',
                                  style: TextStyle(color: Colors.white)),
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
                              'Bukti Pembayaran Transaksi',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            for (PaymentModel paymentModel
                                in state.transactionModel.payment!)
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return PaymentDetail(
                                            paymentModel: paymentModel);
                                      })).then(onGoBack);
                                    },
                                    title: Text(paymentModel.paymentCode ?? ''),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(currencyId
                                            .format(paymentModel.totalPayment)),
                                        Text(
                                          paymentModel.createdAt ?? '',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(paymentModel.status ?? '',
                                            style: TextStyle(
                                                color: Colors.orange)),
                                      ],
                                    ),
                                    // isThreeLine: true,
                                    leading: Container(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: CustomCachedImage.build(
                                            context,
                                            imgUrl: paymentModel
                                                            .imagesPayment !=
                                                        null &&
                                                    paymentModel
                                                            .imagesPayment !=
                                                        ''
                                                ? paymentModel.imagesPayment!
                                                : 'https://picsum.photos/64',
                                          ),
                                        ),
                                      ),
                                    ),
                                    trailing: Icon(
                                      paymentModel.status! == 'success'
                                          ? Icons.check_circle
                                          : paymentModel.status! == 'pending'
                                              ? Icons.timer
                                              : Icons.cancel,
                                      color: paymentModel.status! == 'success'
                                          ? Colors.green.shade600
                                          : paymentModel.status! == 'pending'
                                              ? Colors.orange.shade600
                                              : Colors.red.shade600,
                                    )),
                              ),
                            Divider(),
                            state.transactionModel.statusOrder != 'done' &&
                                    state.transactionModel.totalAllPrice! > dp
                                ? TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.grey.shade600),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Payment(
                                          transactionModel:
                                              state.transactionModel,
                                          dpNominal: dp,
                                        );
                                      })).then(onGoBack);
                                    },
                                    child: Text('Tambah Pembayaran',
                                        style: TextStyle(color: Colors.white)),
                                  )
                                : Container(),
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
                              'Kesan & Pesan (opsional)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Divider(),
                            for (ComplainModel complainModel
                                in listComplainsUser)
                              Column(
                                children: [
                                  Container(
                                    width: size.width,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Colors.grey.shade300)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(complainModel.description ?? ''),
                                        Text(
                                          complainModel.createdAt ?? '',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade100),
                              child: TextField(
                                controller: complainController,
                                textInputAction: TextInputAction.done,
                                minLines: 3,
                                maxLines: 10,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        'Masukkan kesan & pesan anda disini (jika ada)...'),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey.shade600),
                              onPressed: () {
                                // getComplainUser();
                                if (complainController.text == '') {
                                  CustomSnackbar.showSnackbar(
                                      context,
                                      'Input tidak boleh kosong',
                                      SnackbarType.warning);
                                } else {
                                  sendComplain(state.transactionModel.id!);
                                }
                              },
                              child: Text('Kirim Complain',
                                  style: TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
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
        ));
  }
}
