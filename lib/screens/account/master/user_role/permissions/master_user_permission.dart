import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/role_permission_bloc/role_permission_bloc.dart';
import 'package:tukangku/screens/account/master/user_role/permissions/master_user_permission_edit.dart';

class MasterUserPermission extends StatefulWidget {
  const MasterUserPermission({Key? key}) : super(key: key);

  @override
  _MasterUserPermissionState createState() => _MasterUserPermissionState();
}

class _MasterUserPermissionState extends State<MasterUserPermission> {
  late RolePermissionBloc rolePermissionBloc;
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
      rolePermissionBloc.add(GetRolePermission(10, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    rolePermissionBloc.add(GetRolePermission(10, true));
    print('Refresing...');
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    rolePermissionBloc.add(GetRolePermission(10, true));
  }

  @override
  void initState() {
    rolePermissionBloc = BlocProvider.of<RolePermissionBloc>(context);
    rolePermissionBloc.add(GetRolePermission(10, true));

    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RolePermissionBloc, RolePermissionState>(
      listener: (context, state) {
        if (state is RolePermissionData) {
          _hasReachMax = state.hasReachMax;
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Role Permission',
                style: TextStyle(color: Colors.black87),
              ),
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed('/master-user-permission-create')
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
            child: BlocBuilder<RolePermissionBloc, RolePermissionState>(
              builder: (context, state) {
                if (state is RolePermissionData) {
                  return ListView.separated(
                    controller: _scrollController,
                    itemCount: state.hasReachMax
                        ? state.listRolePermissions.length
                        : state.listRolePermissions.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.listRolePermissions.length) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MasterUserPermissionEdit(
                                        rolePermissionModel:
                                            state.listRolePermissions[index],
                                      )),
                            ).then(onGoBack);
                          },
                          title: Container(
                            child: Text(
                              state.listRolePermissions[index].name ?? '',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          subtitle: Text(
                              state.listRolePermissions[index].guardName ?? ''),
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
