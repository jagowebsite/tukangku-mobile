import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/transaction_bloc/transaction_bloc.dart';
import 'package:tukangku/models/transaction_model.dart';
import 'package:tukangku/screens/account/master/transaction/master_transaction_detail.dart';
import 'package:tukangku/screens/widgets/custom_cached_image.dart';

class MasterTransaction extends StatefulWidget {
  const MasterTransaction({Key? key}) : super(key: key);

  @override
  _MasterTransactionState createState() => _MasterTransactionState();
}

class _MasterTransactionState extends State<MasterTransaction> {
  late TransactionBloc transactionBloc;
  ScrollController _scrollController = ScrollController();

  /// Set default hasReachMax value false
  /// Variabel ini digunakan untuk menangani agaer scrollController tidak-
  /// Berlangsung terus menerus.
  bool _hasReachMax = false;

  void onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll && !_hasReachMax) {
      print('iam scrolling');
      transactionBloc.add(GetTransaction(10, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    transactionBloc.add(GetTransaction(10, true));
    print('Refresing...');
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    transactionBloc.add(GetTransaction(10, true));
  }

  @override
  void initState() {
    transactionBloc = BlocProvider.of<TransactionBloc>(context);
    transactionBloc.add(GetTransaction(10, true));

    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionData) {
          _hasReachMax = state.hasReachMax;
        }
      },
      child: Scaffold(
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
          body: RefreshIndicator(
            backgroundColor: Colors.white,
            color: Colors.orangeAccent.shade700,
            displacement: 20,
            onRefresh: () => _refresh(),
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionData) {
                  return ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        if (index < state.listTransactions.length) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MasterTransactionDetail(
                                    transactionModel:
                                        state.listTransactions[index]);
                              })).then(onGoBack);
                            },
                            isThreeLine: true,
                            title: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text(
                                '${state.listTransactions[index].invoiceId} - ${state.listTransactions[index].user!.name}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            subtitle: detailListTransaction(state
                                .listTransactions[index].transactionDetail!),
                            trailing: Column(
                              children: [
                                Text(
                                    state.listTransactions[index].statusOrder ??
                                        ''),
                                state.listTransactions[index].statusOrder! ==
                                        'done'
                                    ? Icon(Icons.check_circle_outline,
                                        color: Colors.green.shade600)
                                    : state.listTransactions[index]
                                                    .statusOrder! ==
                                                'pending' ||
                                            state.listTransactions[index]
                                                    .statusOrder! ==
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
                                  color: Colors.orange.shade600,
                                  strokeWidth: 2),
                            ),
                          );
                        }
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          thickness: 0.3,
                        );
                      },
                      itemCount: state.hasReachMax
                          ? state.listTransactions.length
                          : state.listTransactions.length + 1);
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

  Widget detailListTransaction(List<TransactionDetail>? transactionDetail) {
    List<Widget> list = [];
    for (var i = 0; i < transactionDetail!.length; i++) {
      list.add(
        Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                child: ClipRRect(
                    child: CustomCachedImage.build(
                  context,
                  borderRadius: BorderRadius.circular(5),
                  imgUrl: transactionDetail[i].serviceModel!.images![0],
                )),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transactionDetail[i].serviceModel!.name ?? ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: list);
  }
}
