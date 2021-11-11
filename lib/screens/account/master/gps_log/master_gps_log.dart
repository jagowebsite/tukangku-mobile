import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/log_bloc/log_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class MasterGPSLog extends StatefulWidget {
  const MasterGPSLog({Key? key}) : super(key: key);

  @override
  _MasterGPSLogState createState() => _MasterGPSLogState();
}

class _MasterGPSLogState extends State<MasterGPSLog> {
  late LogBloc logBloc;

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
      logBloc.add(GetGPSLog(10, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    logBloc.add(GetGPSLog(10, true));
    print('Refresing...');
  }

  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    logBloc.add(GetGPSLog(10, true));
  }

  @override
  void initState() {
    logBloc = BlocProvider.of<LogBloc>(context);
    logBloc.add(GetGPSLog(10, true));

    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogBloc, LogState>(
      listener: (context, state) {
        if (state is GPSLogData) {
          _hasReachMax = state.hasReachMax;
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Log GPS Pembeli',
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
            child: BlocBuilder<LogBloc, LogState>(
              builder: (context, state) {
                if (state is GPSLogData) {
                  return ListView.separated(
                    controller: _scrollController,
                    itemCount: state.hasReachMax
                        ? state.listGPSLogs.length
                        : state.listGPSLogs.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.listGPSLogs.length) {
                        return ListTile(
                          onTap: () => _launchURL(
                              'http://maps.google.com/maps?q=${state.listGPSLogs[index].latitude},${state.listGPSLogs[index].longitude}'),
                          title: Container(
                            child: Text(
                              state.listGPSLogs[index].address ?? '',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          isThreeLine: true,
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(state.listGPSLogs[index].latitude ?? ''),
                              Text(
                                state.listGPSLogs[index].longitude ?? '',
                              ),
                              Text(
                                'Invoice : ' +
                                    (state.listGPSLogs[index].invoiceId ?? ''),
                                style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.location_on, color: Colors.red),
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
