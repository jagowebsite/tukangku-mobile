import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/payment_bloc/payment_bloc.dart';
import 'package:tukangku/screens/account/master/payment/master_payment_detail.dart';
import 'package:tukangku/utils/currency_format.dart';

class MasterPayment extends StatefulWidget {
  const MasterPayment({Key? key}) : super(key: key);

  @override
  _MasterPaymentState createState() => _MasterPaymentState();
}

class _MasterPaymentState extends State<MasterPayment> {
  late PaymentBloc paymentBloc;
  ScrollController _scrollController = ScrollController();

  /// Set default hasReachMax value false
  /// Variabel ini digunakan untuk menangani agar scrollController tidak-
  /// Berlangsung terus menerus.
  bool _hasReachMax = false;

  void onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll && !_hasReachMax) {
      print('iam scrolling');
      paymentBloc.add(GetPayment(10, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    paymentBloc.add(GetPayment(10, true));
    print('Refresing...');
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    paymentBloc.add(GetPayment(10, true));
  }

  @override
  void initState() {
    paymentBloc = BlocProvider.of<PaymentBloc>(context);
    paymentBloc.add(GetPayment(10, true));

    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentData) {
          _hasReachMax = state.hasReachMax;
        }
      },
      child: Scaffold(
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
          body: RefreshIndicator(
            backgroundColor: Colors.white,
            color: Colors.orangeAccent.shade700,
            displacement: 20,
            onRefresh: () => _refresh(),
            child: BlocBuilder<PaymentBloc, PaymentState>(
              builder: (context, state) {
                if (state is PaymentData) {
                  return ListView.separated(
                    itemCount: state.hasReachMax
                        ? state.listPayments.length
                        : state.listPayments.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.listPayments.length) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MasterPaymentDetail(
                                  paymentModel: state.listPayments[index]);
                            })).then(onGoBack);
                          },
                          title: Container(
                            child: Text(
                              '${state.listPayments[index].paymentCode} - ${state.listPayments[index].accountName}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          isThreeLine: true,
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(state.listPayments[index].createdAt ?? ''),
                              SizedBox(
                                height: 5,
                              ),
                              Text(currencyId
                                  .format(
                                      state.listPayments[index].totalPayment)
                                  .toString()),
                              SizedBox(
                                height: 5,
                              ),
                              
                            ],
                          ),
                          trailing: Column(
                              children: [
                                Text(
                                    state.listPayments[index].status ??
                                        ''),
                                state.listPayments[index].status! ==
                                        'done' || state.listPayments[index].status! ==
                                        'success'
                                    ? Icon(Icons.check_circle_outline,
                                        color: Colors.green.shade600)
                                    : state.listPayments[index]
                                                    .status! ==
                                                'pending' ||
                                            state.listPayments[index]
                                                    .status! ==
                                                'process'
                                        ? Icon(Icons.timer,
                                            color: Colors.orange.shade600)
                                        : Icon(Icons.cancel,
                                            color: Colors.grey.shade600),
                              ],
                            ),
                        );
                      } else {
                        return Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                                color: Colors.orange.shade600, strokeWidth: 2),
                          ),
                        );
                      }
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        thickness: 0.5,
                      );
                    },
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
          )),
    );
  }
}
