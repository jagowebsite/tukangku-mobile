import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tukangku/blocs/auth_bloc/auth_bloc.dart';
import 'package:tukangku/blocs/profile_bloc/profile_bloc.dart';
import 'package:tukangku/models/user_model.dart';
import 'package:tukangku/screens/widgets/custom_cached_image.dart';
import 'package:tukangku/screens/widgets/input_text.dart';
import 'package:tukangku/utils/custom_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

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

  File? ktpFile;

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ktpFile = File(image.path);
      setState(() {});
    }
  }

  Future urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    ktpFile = file;

    setState(() {});
  }

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

  Future updateKTP() async {
    if (ktpFile == null) {
      CustomSnackbar.showSnackbar(
          context, 'Silahkan pilih foto ktp', SnackbarType.warning);
    } else {
      profileBloc.add(UpdateKTP(ktpFile!));
    }
  }

  Future updateProfile() async {
    if (nameController.text == '' ||
        dateBirthController.text == '' ||
        telpController.text == '' ||
        addressController.text == '') {
      CustomSnackbar.showSnackbar(
          context,
          'Input data profil tidak boleh ada yang kosong',
          SnackbarType.warning);
    } else {
      User user = User(
          name: nameController.text,
          dateOfBirth: dateBirthController.text,
          number: telpController.text,
          address: addressController.text);
      profileBloc.add(UpdateProfile(user));
    }
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
    Size size = MediaQuery.of(context).size;
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authorized) {
              nameController.text = state.user.name ?? '';
              dateBirthController.text = state.user.dateOfBirth ?? '';
              telpController.text = state.user.number ?? '';
              addressController.text = state.user.address ?? '';
              if (state.user.ktpImage != null && state.user.ktpImage != '') {
                urlToFile(state.user.ktpImage ?? '');
              }
            }
          },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              CustomSnackbar.showSnackbar(
                  context, state.message, SnackbarType.success);
              authBloc.add(GetAuthData());
            } else if (state is UpdateProfileError) {
              CustomSnackbar.showSnackbar(
                  context, state.message, SnackbarType.error);
            } else if (state is UpdatePhotoSuccess) {
              CustomSnackbar.showSnackbar(
                  context, state.message, SnackbarType.success);
              authBloc.add(GetAuthData());
            } else if (state is UpdatePhotoError) {
              CustomSnackbar.showSnackbar(
                  context, state.message, SnackbarType.error);
            } else if (state is UpdateKTPSuccess) {
              CustomSnackbar.showSnackbar(
                  context, state.message, SnackbarType.success);
              authBloc.add(GetAuthData());
            } else if (state is UpdateKTPError) {
              CustomSnackbar.showSnackbar(
                  context, state.message, SnackbarType.error);
              // authBloc.add(GetAuthData());
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
                        padding: EdgeInsets.only(top: 10, bottom: 5),
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return Text(
                                state is Authorized
                                    ? (state.user.name ?? 'Tukangkita!')
                                    : 'Tukangkita!',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold));
                          },
                        )),
                  ),
                  Center(
                    child: Container(
                        padding: EdgeInsets.only(
                          bottom: 10,
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
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text('Profile Lengkap Anda')),
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
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () => updateProfile(),
                    child: Container(
                      color: Colors.white,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent.shade700,
                          ),
                          child: Center(
                            child: Text('Update Profil',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                )),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text('Foto KTP Anda')),
                  GestureDetector(
                    onTap: () => pickImage(),
                    child: Container(
                        width: size.width,
                        height: 150,
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
                                        color: Colors.orangeAccent.shade700))
                                : Container(
                                    child: Image.file(ktpFile!),
                                  ))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () => updateKTP(),
                    child: Container(
                      color: Colors.white,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent.shade700,
                          ),
                          child: Center(
                            child: Text('Upload KTP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                )),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                          '* Pastikan data yang anda masukkan sudah benar')),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is UpdateProfileLoading ||
                    state is UpdateKTPLoading) {
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
