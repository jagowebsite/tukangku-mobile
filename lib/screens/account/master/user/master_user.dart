import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/user_data_bloc/user_data_bloc.dart';
import 'package:tukangku/screens/account/master/user/master_user_edit.dart';

class MasterUser extends StatefulWidget {
  const MasterUser({Key? key}) : super(key: key);

  @override
  _MasterUserState createState() => _MasterUserState();
}

class _MasterUserState extends State<MasterUser> {
  late UserDataBloc userDataBloc;
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
      userDataBloc.add(GetUserData(10, false, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    userDataBloc.add(GetUserData(10, true, false));
    print('Refresing...');
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    userDataBloc.add(GetUserData(10, true, false));
  }

  @override
  void initState() {
    userDataBloc = BlocProvider.of<UserDataBloc>(context);
    userDataBloc.add(GetUserData(10, true, false));

    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserDataBloc, UserDataState>(
      listener: (context, state) {
        if (state is UserData) {
          _hasReachMax = state.hasReachMax;
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Master Data Admin',
                style: TextStyle(color: Colors.black87),
              ),
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed('/master-user-create')
                      .then(onGoBack),
                  icon: Icon(
                    Icons.add,
                    color: Colors.black87,
                  ),
                )
              ],
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
            child: BlocBuilder<UserDataBloc, UserDataState>(
              builder: (context, state) {
                if (state is UserData) {
                  return ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: state.hasReachMax
                        ? state.listUsers.length
                        : state.listUsers.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.listUsers.length) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MasterUserEdit(
                                  user: state.listUsers[index]);
                            })).then(onGoBack);
                          },
                          leading: Container(
                            decoration: BoxDecoration(
                                color: Colors.orange, shape: BoxShape.circle),
                            child: Container(
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    state.listUsers[index].images ?? ''),
                              ),
                            ),
                          ),
                          title: Container(
                            child: Text(
                              state.listUsers[index].name ?? '',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          subtitle: Text(state.listUsers[index].email ?? ''),
                          trailing:
                              Icon(Icons.chevron_right, color: Colors.black87),
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
