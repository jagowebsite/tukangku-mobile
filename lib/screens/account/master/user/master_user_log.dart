import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/log_bloc/log_bloc.dart';

class MasterUserLog extends StatefulWidget {
  const MasterUserLog({Key? key}) : super(key: key);

  @override
  _MasterUserLogState createState() => _MasterUserLogState();
}

class _MasterUserLogState extends State<MasterUserLog> {
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
      logBloc.add(GetUserLog(10, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    logBloc.add(GetUserLog(10, true));
    print('Refresing...');
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    logBloc.add(GetUserLog(10, true));
  }

  @override
  void initState() {
    logBloc = BlocProvider.of<LogBloc>(context);
    logBloc.add(GetUserLog(10, true));

    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogBloc, LogState>(
      listener: (context, state) {
        if (state is UserLogData) {
          _hasReachMax = state.hasReachMax;
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'User Log',
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
                if (state is UserLogData) {
                  return ListView.separated(
                    controller: _scrollController,
                    itemCount: state.hasReachMax
                        ? state.listUserLogs.length
                        : state.listUserLogs.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.listUserLogs.length) {
                        return ListTile(
                          onTap: () {},
                          title: Container(
                            child: Text(
                              state.listUserLogs[index].user!.name ?? '',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(state.listUserLogs[index].user!.email ?? ''),
                              Text(state.listUserLogs[index].description ?? ''),
                              Text(state.listUserLogs[index].createdAt ?? ''),
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
