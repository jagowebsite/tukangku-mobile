import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/role_access_bloc/role_access_bloc.dart';
import 'package:tukangku/models/role_model.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class MasterUserRoleCreate extends StatefulWidget {
  const MasterUserRoleCreate({Key? key}) : super(key: key);

  @override
  _MasterUserRoleCreateState createState() => _MasterUserRoleCreateState();
}

class _MasterUserRoleCreateState extends State<MasterUserRoleCreate> {
  late RoleAccessBloc roleAccessBloc;

  TextEditingController nameController = TextEditingController();
  TextEditingController guardController = TextEditingController();

  Future createRoleAccess() async {
    RoleAccessModel roleAccessModel = RoleAccessModel(
        name: nameController.text, guardName: guardController.text);
    roleAccessBloc.add(CreateRoleAccess(roleAccessModel));
  }

  @override
  void initState() {
    roleAccessBloc = BlocProvider.of<RoleAccessBloc>(context);
    guardController.text = 'web';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<RoleAccessBloc, RoleAccessState>(
      listener: (context, state) {
        if (state is CreateRoleAccessSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is CreateRoleAccessError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Tambah Role Akses',
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
                      onPressed: () => createRoleAccess(),
                      child:
                          Text('Simpan', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
            BlocBuilder<RoleAccessBloc, RoleAccessState>(
              builder: (context, state) {
                if (state is CreateRoleAccessLoading) {
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
