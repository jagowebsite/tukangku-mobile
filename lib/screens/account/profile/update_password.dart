import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/profile_bloc/profile_bloc.dart';
import 'package:tukangku/screens/widgets/input_text.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  late ProfileBloc profileBloc;

  TextEditingController _currentPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  updatePassword() {
    if (_currentPassword.text == '' ||
        _newPassword.text == '' ||
        _confirmPassword.text == '') {
      CustomSnackbar.showSnackbar(
          context, 'Input tidak boleh ada yang kosong', SnackbarType.warning);
    } else if (_newPassword.text != _confirmPassword.text) {
      CustomSnackbar.showSnackbar(
          context,
          'Password baru dan konfirmasi password harus sama',
          SnackbarType.warning);
    } else {
      profileBloc.add(ChangePassword(
          _currentPassword.text, _newPassword.text, _confirmPassword.text));
    }
  }

  @override
  void initState() {
    profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is ChangePasswordError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Update Password',
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
                children: [
                  InputText(
                    controller: _currentPassword,
                    hintText: 'Password Sekarang',
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InputText(
                    controller: _newPassword,
                    hintText: 'Password Baru',
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InputText(
                    controller: _confirmPassword,
                    hintText: 'Konfirmasi Password',
                    obscureText: true,
                  ),
                ],
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () => updatePassword(),
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
                          child: Text('Update Password',
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
                if (state is ChangePasswordLoading) {
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
