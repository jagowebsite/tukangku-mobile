import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/history_bloc/history_bloc.dart';
import 'package:tukangku/screens/widgets/custom_cached_image.dart';
import 'package:tukangku/utils/currency_format.dart';

class HistoryEmployee extends StatefulWidget {
  const HistoryEmployee({Key? key}) : super(key: key);

  @override
  _HistoryEmployeeState createState() => _HistoryEmployeeState();
}

class _HistoryEmployeeState extends State<HistoryEmployee> {
  late HistoryBloc historyBloc;
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
      historyBloc.add(GetHistoryEmployee(10, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    historyBloc.add(GetHistoryEmployee(10, true));
    print('Refresing...');
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    historyBloc.add(GetHistoryEmployee(10, true));
  }

  @override
  void initState() {
    historyBloc = BlocProvider.of<HistoryBloc>(context);
    historyBloc.add(GetHistoryEmployee(10, true));

    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HistoryBloc, HistoryState>(
      listener: (context, state) {
        if (state is HistoryEmployeeData) {
          _hasReachMax = state.hasReachMax;
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'History Pekerjaan Tukang',
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
            child: BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                if (state is HistoryEmployeeData) {
                  return ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        if (index < state.listHistories.length) {
                          return ListTile(
                            onTap: () {},
                            isThreeLine: true,
                            leading: Container(
                              width: 60,
                              height: 60,
                              child: ClipRRect(
                                  child: CustomCachedImage.build(
                                context,
                                imgUrl: state
                                    .listHistories[index]
                                    .historyEmployeeDetail!
                                    .serviceModel!
                                    .images![0],
                              )),
                            ),
                            title: Container(
                              child: Text(
                                '${state.listHistories[index].employeeModel!.name}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${state.listHistories[index].createdAt}'),
                                Text(state
                                    .listHistories[index]
                                    .historyEmployeeDetail!
                                    .serviceModel!
                                    .name!),
                                Text(
                                    '${state.listHistories[index].workDuration.toString()} ${state.listHistories[index].typeWorkDuration.toString()}'),
                                Text(
                                    'Total Harga - ${currencyId.format(state.listHistories[index].historyEmployeeDetail!.totalPrice).toString()}'),
                                Text(
                                    'Upah - ${currencyId.format(state.listHistories[index].salaryEmployee).toString()}'),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(state
                                        .listHistories[index]
                                        .historyEmployeeDetail!
                                        .statusOrderDetail ??
                                    ''),
                                state
                                            .listHistories[index]
                                            .historyEmployeeDetail!
                                            .statusOrderDetail ==
                                        'done'
                                    ? Icon(Icons.check_circle_outline,
                                        color: Colors.green.shade600)
                                    : state
                                                    .listHistories[index]
                                                    .historyEmployeeDetail!
                                                    .statusOrderDetail ==
                                                'pending' ||
                                            state
                                                    .listHistories[index]
                                                    .historyEmployeeDetail!
                                                    .statusOrderDetail ==
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
                          ? state.listHistories.length
                          : state.listHistories.length + 1);
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
