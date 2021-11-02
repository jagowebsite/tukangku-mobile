import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/auth_bloc/auth_bloc.dart';
import 'package:tukangku/blocs/profile_bloc/profile_bloc.dart';
import 'package:tukangku/models/user_model.dart';
import 'package:tukangku/screens/widgets/custom_cached_image.dart';
import 'package:tukangku/screens/widgets/input_text.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class UpdateProfil extends StatefulWidget {
  const UpdateProfil({Key? key}) : super(key: key);

  @override
  _UpdateProfilState createState() => _UpdateProfilState();
}

class _UpdateProfilState extends State<UpdateProfil> {
  late AuthBloc authBloc;
  late ProfileBloc profileBloc;

  TextEditingController nameController = TextEditingController();
  TextEditingController dateBirthController = TextEditingController();
  TextEditingController telpController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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
        dateBirthController.text =
            selectedDate.toLocal().toString().split(' ')[0];
      });
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    authBloc.add(GetAuthData());
  }

  Future updateProfile() async {
    User user = User(
        name: nameController.text,
        dateOfBirth: dateBirthController.text,
        number: telpController.text,
        address: addressController.text);
    profileBloc.add(UpdateProfile(user));
  }

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    profileBloc = BlocProvider.of<ProfileBloc>(context);
    authBloc.add(GetAuthData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authorized) {
              nameController.text = state.user.name ?? '';
              dateBirthController.text = state.user.dateOfBirth ?? '';
              telpController.text = state.user.number ?? '';
              addressController.text = state.user.address ?? '';
            }
          },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              CustomSnackbar.showSnackbar(
                  context, state.message, SnackbarType.success);
            } else if (state is UpdateProfileError) {
              CustomSnackbar.showSnackbar(
                  context, state.message, SnackbarType.error);
            } else if (state is UpdatePhotoSuccess) {
              CustomSnackbar.showSnackbar(
                  context, state.message, SnackbarType.success);
            } else if (state is UpdatePhotoError) {
              CustomSnackbar.showSnackbar(
                  context, state.message, SnackbarType.error);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Update Profil',
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
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushNamed('/image-cropper')
                            .then(onGoBack),
                        child: Stack(
                          children: [
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  child: CircleAvatar(
                                    child: ClipOval(
                                      child: CustomCachedImage.build(context,
                                          imgUrl: state is Authorized
                                              ? (state.user.images ??
                                                  'https://i.pravatar.cc/300')
                                              : 'https://i.pravatar.cc/300'),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Positioned(
                                child: Align(
                              alignment: Alignment.bottomRight,
                              child: ClipOval(
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  color: Colors.black87,
                                  child: Icon(Icons.camera_alt,
                                      size: 15, color: Colors.white),
                                ),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return Text(state is Authorized
                                ? (state.user.email ?? 'Hello!')
                                : 'Hello!');
                          },
                        )),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  InputText(
                    controller: nameController,
                    hintText: 'Nama Lengkap',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      InputText(
                        controller: dateBirthController,
                        readOnly: true,
                        hintText: 'Tanggal Lahir',
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
                  InputText(
                    controller: telpController,
                    hintText: 'No Telp',
                    textInputType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InputText(
                    controller: addressController,
                    hintText: 'Alamat Lengkap',
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () => updateProfile(),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    color: Colors.white,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.orangeAccent.shade700),
                            color: Colors.orangeAccent.shade700,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text('Update Profil',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              )),
                        )),
                  ),
                ),
              ),
            ),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is UpdateProfileLoading) {
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
