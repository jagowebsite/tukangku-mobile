import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/role_permission_bloc/role_permission_bloc.dart';
import 'package:tukangku/models/role_model.dart';
import 'package:tukangku/screens/widgets/bottom_sheet_modal.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class MasterUserPermissionEdit extends StatefulWidget {
  final RolePermissionModel rolePermissionModel;
  const MasterUserPermissionEdit({Key? key, required this.rolePermissionModel})
      : super(key: key);

  @override
  _MasterUserPermissionEditState createState() =>
      _MasterUserPermissionEditState();
}

class _MasterUserPermissionEditState extends State<MasterUserPermissionEdit> {
  late RolePermissionBloc rolePermissionBloc;
  TextEditingController nameController = TextEditingController();
  TextEditingController guardController = TextEditingController();

  Future deleteRolePermission() async {
    RolePermissionModel rolePermissionModel =
        RolePermissionModel(id: widget.rolePermissionModel.id);
    BottomSheetModal.show(context, children: [
      const Text('Apakah kamu yakin ingin menghapus?'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(primary: Colors.orangeAccent.shade700),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
            onPressed: () {
              rolePermissionBloc.add(DeleteRolePermission(rolePermissionModel));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ]);
  }

  Future updateRolePermission() async {
    RolePermissionModel rolePermissionModel = RolePermissionModel(
        id: widget.rolePermissionModel.id,
        name: nameController.text,
        guardName: guardController.text);

    rolePermissionBloc.add(UpdateRolePermission(rolePermissionModel));
  }

  initValue() {
    nameController.text = widget.rolePermissionModel.name ?? '';
    guardController.text = widget.rolePermissionModel.guardName ?? '';
  }

  @override
  void initState() {
    rolePermissionBloc = BlocProvider.of<RolePermissionBloc>(context);
    initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<RolePermissionBloc, RolePermissionState>(
      listener: (context, state) {
        if (state is UpdateRolePermissionSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is UpdateRolePermissionError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        } else if (state is DeleteRolePermissionSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is DeleteRolePermissionError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              widget.rolePermissionModel.name ?? '',
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
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    width: size.width,
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Text(
                              'Data Permission',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Nama Permission'),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade100),
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Contoh: Admin...'),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Guard Name'),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade100),
                          child: TextField(
                            controller: guardController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Contoh: Web, Api...'),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 7,
                              offset: Offset(0, 5),
                            )
                          ],
                        ),
                        child: Container(
                          color: Colors.red.shade500,
                          child: TextButton(
                            onPressed: () => deleteRolePermission(),
                            child: Text('Delete',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 7,
                              offset: Offset(0, 5),
                            )
                          ],
                        ),
                        child: Container(
                          color: Colors.orangeAccent.shade700,
                          child: TextButton(
                            onPressed: () => updateRolePermission(),
                            child: Text('Update',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<RolePermissionBloc, RolePermissionState>(
              builder: (context, state) {
                if (state is UpdateRolePermissionLoading ||
                    state is DeleteRolePermissionLoading) {
                  return Container(
                      color: Colors.white.withOpacity(0.5),
                      child: Center(
                        child: Container(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              color: Colors.orangeAccent.shade700,
                              strokeWidth: 3,
                            )),
                      ));
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
