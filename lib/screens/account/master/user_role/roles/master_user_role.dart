import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/role_access_bloc/role_access_bloc.dart';
import 'package:tukangku/screens/account/master/user_role/roles/master_user_role_edit.dart';

class MasterUserRole extends StatefulWidget {
  const MasterUserRole({Key? key}) : super(key: key);

  @override
  _MasterUserRoleState createState() => _MasterUserRoleState();
}

class _MasterUserRoleState extends State<MasterUserRole> {
  late RoleAccessBloc roleAccessBloc;
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
      roleAccessBloc.add(GetRoleAccess(10, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    roleAccessBloc.add(GetRoleAccess(10, true));
    print('Refresing...');
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    roleAccessBloc.add(GetRoleAccess(10, true));
  }

  @override
  void initState() {
    roleAccessBloc = BlocProvider.of<RoleAccessBloc>(context);
    roleAccessBloc.add(GetRoleAccess(10, true));

    _scrollController.addListener(onScroll);
    super.initState();
  }

  List<String> roles = [
    'Superadmin',
    'Administrator',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoleAccessBloc, RoleAccessState>(
      listener: (context, state) {
        if (state is RoleAccessData) {
          _hasReachMax = state.hasReachMax;
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Role Akses',
                style: TextStyle(color: Colors.black87),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed('/master-user-role-create')
                      .then(onGoBack),
                  icon: Icon(
                    Icons.add,
                    color: Colors.black87,
                  ),
                )
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
            child: BlocBuilder<RoleAccessBloc, RoleAccessState>(
              builder: (context, state) {
                if (state is RoleAccessData) {
                  return ListView.separated(
                    controller: _scrollController,
                    itemCount: state.hasReachMax
                        ? state.listRoleAccesss.length
                        : state.listRoleAccesss.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.listRoleAccesss.length) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MasterUserRoleEdit(
                                        roleAccessModel:
                                            state.listRoleAccesss[index],
                                      )),
                            ).then(onGoBack);
                          },
                          title: Container(
                            child: Text(
                              state.listRoleAccesss[index].name ?? '',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          subtitle: Text(
                              state.listRoleAccesss[index].guardName ?? ''),
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
