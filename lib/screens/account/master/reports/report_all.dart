import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/report_bloc/report_bloc.dart';
import 'package:tukangku/screens/widgets/custom_cached_image.dart';
import 'package:tukangku/utils/currency_format.dart';

class ReportAll extends StatefulWidget {
  const ReportAll({Key? key}) : super(key: key);

  @override
  _ReportAllState createState() => _ReportAllState();
}

class _ReportAllState extends State<ReportAll> {
  late ReportBloc reportBloc;
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
      reportBloc.add(GetReportAll(10, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    reportBloc.add(GetReportAll(10, true));
    print('Refresing...');
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    reportBloc.add(GetReportAll(10, true));
  }

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  // Date Picker
  DateTime selectedFromDate = DateTime.now().subtract(Duration(days: 30));
  DateTime selectedToDate = DateTime.now();
  DateTime now = new DateTime.now();

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedFromDate,
        firstDate: DateTime((now.year - 100), 8),
        lastDate: DateTime(now.year + 1));
    if (picked != null && picked != selectedFromDate)
      setState(() {
        selectedFromDate = picked;
        fromDateController.text =
            selectedFromDate.toLocal().toString().split(' ')[0];
      });
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedToDate,
        firstDate: DateTime((now.year - 100), 8),
        lastDate: DateTime(now.year + 1));
    if (picked != null && picked != selectedToDate)
      setState(() {
        selectedToDate = picked;
        toDateController.text =
            selectedToDate.toLocal().toString().split(' ')[0];
      });
  }

  Future downloadExcel() async {
    print('Downloading report...');
  }

  @override
  void initState() {
    reportBloc = BlocProvider.of<ReportBloc>(context);
    reportBloc.add(GetReportAll(10, true));

    fromDateController.text =
        '${now.year}-${(now.month - 1).toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    toDateController.text =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBloc, ReportState>(
      listener: (context, state) {
        if (state is ReportAllData) {
          _hasReachMax = state.hasReachMax;
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Laporan Seluruh Penjual',
                style: TextStyle(color: Colors.black87),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () => _showMyDialog(),
                    icon: Icon(
                      Icons.download,
                      color: Colors.black87,
                    ))
              ],
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
            child: BlocBuilder<ReportBloc, ReportState>(
              builder: (context, state) {
                if (state is ReportAllData) {
                  return ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        if (index < state.listReports.length) {
                          return ListTile(
                            onTap: () {},
                            isThreeLine: true,
                            leading: Container(
                              width: 60,
                              height: 60,
                              child: ClipRRect(
                                  child: CustomCachedImage.build(
                                context,
                                imgUrl: state.listReports[index].serviceModel!
                                    .images![0],
                              )),
                            ),
                            title: Container(
                              child: Text(
                                '${state.listReports[index].transactionModel!.invoiceId} - ${state.listReports[index].transactionModel!.user!.name}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.listReports[index].createdAt ?? ''),
                                Text(state.listReports[index].serviceModel!
                                        .name ??
                                    ''),
                                Text(currencyId
                                    .format(state.listReports[index].totalPrice)
                                    .toString()),
                              ],
                            ),
                            trailing: Column(
                              children: [
                                Text(state
                                        .listReports[index].statusOrderDetail ??
                                    ''),
                                state.listReports[index].statusOrderDetail! ==
                                        'done'
                                    ? Icon(Icons.check_circle_outline,
                                        color: Colors.green.shade600)
                                    : state.listReports[index]
                                                    .statusOrderDetail! ==
                                                'pending' ||
                                            state.listReports[index]
                                                    .statusOrderDetail! ==
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
                          ? state.listReports.length
                          : state.listReports.length + 1);
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Download Excel Laporan Seluruh Penjual'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Dari tanggal'),
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade100),
                      child: TextField(
                        controller: fromDateController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () async {
                          await _selectFromDate(context);
                        },
                        child: Container(
                          height: 50,
                          color: Colors.transparent,
                        ))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Sampai tanggal'),
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade100),
                      child: TextField(
                        controller: toDateController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () async {
                          await _selectToDate(context);
                        },
                        child: Container(
                          height: 50,
                          color: Colors.transparent,
                        ))
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Download'),
              onPressed: () {
                downloadExcel();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
