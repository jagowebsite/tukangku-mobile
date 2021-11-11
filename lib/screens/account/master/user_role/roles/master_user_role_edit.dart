import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/role_access_bloc/role_access_bloc.dart';
import 'package:tukangku/models/role_model.dart';
import 'package:tukangku/screens/widgets/bottom_sheet_modal.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class MasterUserRoleEdit extends StatefulWidget {
  final RoleAccessModel roleAccessModel;
  const MasterUserRoleEdit({Key? key, required this.roleAccessModel})
      : super(key: key);

  @override
  _MasterUserRoleEditState createState() => _MasterUserRoleEditState();
}

class _MasterUserRoleEditState extends State<MasterUserRoleEdit> {
  late RoleAccessBloc roleAccessBloc;
  RolePermissionModel? permission;
  TextEditingController nameController = TextEditingController();
  TextEditingController guardController = TextEditingController();

  List<RolePermissionModel> listPermissions = [
    RolePermissionModel(id: 1, name: 'Superadmin'),
    RolePermissionModel(id: 2, name: 'Admin'),
  ];

  List<RolePermissionModel> listPermissionsSelected = [];

  void addPermissionToRole() {
    if (permission != null) {
      if (listPermissionsSelected.any((item) => item.id == permission!.id)) {
      } else {
        listPermissionsSelected.add(permission!);
      }
    }
    setState(() {});
  }

  void deletePermissionToRole(RolePermissionModel permissionModel) {
    listPermissionsSelected
        .removeWhere((item) => item.id == permissionModel.id);
    setState(() {});
  }

  Future updateRoleAccess() async {
    RoleAccessModel roleAccessModel = RoleAccessModel(
        id: widget.roleAccessModel.id,
        name: nameController.text,
        guardName: guardController.text);
    roleAccessBloc.add(UpdateRoleAccess(roleAccessModel));
  }

  Future deleteRoleAccess() async {
    RoleAccessModel roleAccessModel =
        RoleAccessModel(id: widget.roleAccessModel.id);
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
              roleAccessBloc.add(DeleteRoleAccess(roleAccessModel));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ]);
  }

  initValue() {
    nameController.text = widget.roleAccessModel.name ?? '';
    guardController.text = widget.roleAccessModel.guardName ?? '';
  }

  @override
  void initState() {
    roleAccessBloc = BlocProvider.of<RoleAccessBloc>(context);
    initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<RoleAccessBloc, RoleAccessState>(
      listener: (context, state) {
        if (state is UpdateRoleAccessSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
        } else if (state is UpdateRoleAccessError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        } else if (state is DeleteRoleAccessSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is DeleteRoleAccessError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              widget.roleAccessModel.name ?? '',
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
                              'Data Role',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Nama Role'),
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
                        TextButton(
                          onPressed: () => updateRoleAccess(),
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: Text('Update',
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
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
                        Text('Tambah permission ke role'),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade100),
                          child: DropdownButton<RolePermissionModel>(
                            dropdownColor: Colors.grey.shade100,
                            value: permission,
                            isExpanded: true,
                            icon: Icon(Icons.expand_more),
                            iconSize: 24,
                            elevation: 1,
                            style: TextStyle(color: Colors.black),
                            underline: Container(),
                            onChanged: (RolePermissionModel? newValue) {
                              setState(() {
                                permission = newValue!;
                              });
                            },
                            items: listPermissions
                                .map((RolePermissionModel value) {
                              return DropdownMenuItem<RolePermissionModel>(
                                value: value,
                                child: Text(value.name ?? ''),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          onPressed: () => addPermissionToRole(),
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: Text('Tambah',
                              style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: [
                            for (RolePermissionModel permissionModel
                                in listPermissionsSelected)
                              Container(
                                margin: EdgeInsets.only(right: 5, bottom: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(permissionModel.name ?? ''),
                                    GestureDetector(
                                        onTap: () => deletePermissionToRole(
                                            permissionModel),
                                        child: Icon(Icons.close))
                                  ],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
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
                      onPressed: () => deleteRoleAccess(),
                      child:
                          Text('Hapus', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
            BlocBuilder<RoleAccessBloc, RoleAccessState>(
              builder: (context, state) {
                if (state is UpdateRoleAccessLoading ||
                    state is DeleteRoleAccessLoading) {
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
