import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tukangku/blocs/user_data_bloc/user_data_bloc.dart';
import 'package:tukangku/models/role_model.dart';
import 'package:tukangku/models/user_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/role_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/screens/widgets/bottom_sheet_modal.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class MasterUserEdit extends StatefulWidget {
  final User user;
  const MasterUserEdit({Key? key, required this.user}) : super(key: key);

  @override
  _MasterUserEditState createState() => _MasterUserEditState();
}

class _MasterUserEditState extends State<MasterUserEdit> {
  late UserDataBloc userDataBloc;
  File? imageFile, ktpFile;

  RoleRepository roleRepo = RoleRepository();
  AuthRepository authRepo = AuthRepository();

  List<RoleAccessModel> listRoles = [];
  RoleAccessModel? roleSelected;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  // Date Picker
  DateTime selectedDate = DateTime.now();
  DateTime now = new DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime((now.year - 100), 8),
        lastDate: DateTime(now.year + 1));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
  }

  Future updateUser() async {
    User user = User(
        id: widget.user.id,
        name: nameController.text,
        // email: emailController.text,
        dateOfBirth: dateController.text,
        number: numberController.text,
        address: addressController.text,
        roleAccessModel: roleSelected,
        imageFile: imageFile,
        ktpImageFile: ktpFile);
    userDataBloc.add(UpdateUserData(user));
  }

  Future changePassword() async {
    if (passwordController.text == '' || passwordConfirmController.text == '') {
      CustomSnackbar.showSnackbar(context,
          'Passwod dan konfirmasi password harus terisi', SnackbarType.warning);
    } else {
      User user = User(
          id: widget.user.id,
          password: passwordController.text,
          passwordConfirmation: passwordConfirmController.text);

      userDataBloc.add(ChangePasswordUserData(user));
    }
  }

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      setState(() {});
    }
  }

  Future pickKTPImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ktpFile = File(image.path);
      setState(() {});
    }
  }

  Future getRoleAccess() async {
    String? _token = await authRepo.hasToken();
    List<RoleAccessModel>? _listRoles = await roleRepo.getRoleAccess(_token!);
    if (_listRoles != null) {
      listRoles = _listRoles;
    }
    setState(() {});
  }

  Future<File> urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future deleteUserData() async {
    User user = User(id: widget.user.id);
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
              userDataBloc.add(DeleteUserData(user));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ]);
  }

  initValue() async {
    emailController.text = widget.user.email ?? '';
    nameController.text = widget.user.name ?? '';
    dateController.text = widget.user.dateOfBirth ?? '';
    numberController.text = widget.user.number ?? '';
    addressController.text = widget.user.address ?? '';

    if (widget.user.images != null && widget.user.images != '') {
      imageFile = await urlToFile(widget.user.images!);
      setState(() {});
    }

    if (widget.user.ktpImage != null && widget.user.ktpImage != '') {
      ktpFile = await urlToFile(widget.user.ktpImage!);
      setState(() {});
    }

    await getRoleAccess();
    for (var i = 0; i < listRoles.length; i++) {
      if (listRoles[i].id == widget.user.roleAccessModel!.id) {
        roleSelected = listRoles[i];
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    userDataBloc = BlocProvider.of<UserDataBloc>(context);
    initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<UserDataBloc, UserDataState>(
      listener: (context, state) {
        if (state is UpdateUserDataSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
        } else if (state is UpdateUserDataError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        } else if (state is ChangePasswordUserDataSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
        } else if (state is DeleteUserDataSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is DeleteUserDataError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        } else if (state is ChangePasswordUserDataError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                widget.user.name ?? '',
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
                                'Data User',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Email'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              readOnly: true,
                              controller: emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Nama'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Tanggal Lahir'),
                          Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade100),
                                child: TextField(
                                  controller: dateController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    await _selectDate(context);
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
                          Text('Nomor Telp'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              controller: numberController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Alamat'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              controller: addressController,
                              textAlignVertical: TextAlignVertical.bottom,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              minLines: 3,
                              maxLines: 10,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Contoh: Service AC adalah...'),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Tambah permission ke role'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: DropdownButton<RoleAccessModel>(
                              dropdownColor: Colors.grey.shade100,
                              value: roleSelected,
                              isExpanded: true,
                              icon: Icon(Icons.expand_more),
                              iconSize: 24,
                              elevation: 1,
                              style: TextStyle(color: Colors.black),
                              underline: Container(),
                              onChanged: (RoleAccessModel? newValue) {
                                setState(() {
                                  roleSelected = newValue!;
                                });
                              },
                              items: listRoles.map((RoleAccessModel value) {
                                return DropdownMenuItem<RoleAccessModel>(
                                  value: value,
                                  child: Text(value.name ?? ''),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                                'Foto User',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () => pickImage(),
                            child: Container(
                                width: size.width,
                                height: 100,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.orangeAccent.shade700,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                    child: imageFile == null
                                        ? Text('+ Pilih Foto',
                                            style: TextStyle(
                                                color: Colors
                                                    .orangeAccent.shade700))
                                        : Container(
                                            child: Image.file(imageFile!),
                                          ))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                                'Foto KTP',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () => pickKTPImage(),
                            child: Container(
                                width: size.width,
                                height: 100,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.orangeAccent.shade700,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                    child: ktpFile == null
                                        ? Text('+ Pilih Foto KTP',
                                            style: TextStyle(
                                                color: Colors
                                                    .orangeAccent.shade700))
                                        : Container(
                                            child: Image.file(ktpFile!),
                                          ))),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          TextButton(
                            onPressed: () => updateUser(),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.orange.shade700),
                            child: Text('Simpan Perubahan',
                                style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text('Password'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Konfirmasi Password'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              controller: passwordConfirmController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          TextButton(
                            onPressed: () => changePassword(),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.orange.shade700),
                            child: Text('Ubah Password User',
                                style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
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
                              color: Colors.red.shade700,
                              child: TextButton(
                                onPressed: () => deleteUserData(),
                                child: Text('Hapus User',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<UserDataBloc, UserDataState>(
                builder: (context, state) {
                  if (state is UpdateUserDataLoading ||
                      state is DeleteUserDataLoading ||
                      state is ChangePasswordUserDataLoading) {
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
          )),
    );
  }
}
