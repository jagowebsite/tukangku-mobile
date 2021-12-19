import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/transaction_user_bloc/transaction_user_bloc.dart';
import 'package:tukangku/models/transaction_model.dart';
import 'package:tukangku/screens/transaction/my_transaction_detail.dart';
import 'package:tukangku/screens/widgets/custom_cached_image.dart';

class MyTransaction extends StatefulWidget {
  const MyTransaction({Key? key}) : super(key: key);

  @override
  _MyTransactionState createState() => _MyTransactionState();
}

class _MyTransactionState extends State<MyTransaction> {
  late TransactionUserBloc transactionUserBloc;
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
      transactionUserBloc.add(GetTransactionUser(10, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    transactionUserBloc.add(GetTransactionUser(10, true));
    print('Refresing...');
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    transactionUserBloc.add(GetTransactionUser(10, true));
  }

  @override
  void initState() {
    transactionUserBloc = BlocProvider.of<TransactionUserBloc>(context);
    transactionUserBloc.add(GetTransactionUser(10, true));

    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionUserBloc, TransactionUserState>(
      listener: (context, state) {
        if (state is TransactionUserData) {
          _hasReachMax = state.hasReachMax;
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Semua Transaksiku',
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
                if (state is TransactionUserData) {
                  return ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      if (index < state.listTransactions.length) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MyTransactionDetail(
                                transactionModel: state.listTransactions[index],
                              );
                            })).then(onGoBack);
                          },
                          isThreeLine: true,
                          // leading: Container(
                          //   width: 60,
                          //   height: 60,
                          //   child: ClipRRect(
                          //       child: CustomCachedImage.build(
                          //     context,
                          //     imgUrl: state
                          //         .listTransactions[index]
                          //         .transactionDetail![0]
                          //         .serviceModel!
                          //         .images![0],
                          //   )),
                          // ),
                          title: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              '${state.listTransactions[index].invoiceId} - ${state.listTransactions[index].user!.name}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          // subtitle: Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     for (TransactionDetail transactionDetail in state
                          //         .listTransactions[index].transactionDetail!)
                          //       Row(
                          //         children: [
                          //           Container(
                          //             width: 30,
                          //             height: 30,
                          //             child: ClipRRect(
                          //                 child: CustomCachedImage.build(
                          //               context,
                          //               borderRadius: BorderRadius.circular(5),
                          //               imgUrl: transactionDetail
                          //                   .serviceModel!.images![0],
                          //             )),
                          //           ),
                          //           SizedBox(width: 5),
                          //           Expanded(
                          //             child: Column(
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.start,
                          //               children: [
                          //                 Text(transactionDetail
                          //                         .serviceModel!.name ??
                          //                     ''),
                          //               ],
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //   ],
                          // ),
                          subtitle: detailListTransaction(
                              state.listTransactions[index].transactionDetail!),
                          trailing: Column(
                            children: [
                              Text(state.listTransactions[index].statusOrder ??
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
                                color: Colors.orange.shade600, strokeWidth: 2),
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
                        : state.listTransactions.length + 1,
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
