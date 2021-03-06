import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/auth_bloc/auth_bloc.dart';
import 'package:tukangku/models/register_model.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:tukangku/screens/auth/login.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late AuthBloc authBloc;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();

  bool privacyCheck = false;
  bool showPassword = true;
  bool showConfirmPass = true;

  Future _registerProcess() async {
    if (_emailController.text == '' ||
        _nameController.text == '' ||
        _passwordController.text == '' ||
        _confirmPassController.text == '' ||
        privacyCheck == false) {
      String message =
          'Pastikan semua input terisi dan tidak boleh ada yang kosong!';
      CustomSnackbar.showSnackbar(context, message, SnackbarType.warning);
    } else {
      RegisterModel registerModel = new RegisterModel(
          name: _nameController.text,
          username: _emailController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPassController.text);
      authBloc.add(RegisterProcess(registerModel));
    }
  }

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(GetAuthData());
    super.initState();
  }

  // @override
  // void dispose() {
  //   authBloc.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(builder: (BuildContext context) => Login()),
            ModalRoute.withName('/login'),
          );
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: state.message,
          );
        } else if (state is RegisterError) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.warning,
            text: state.message,
          );
        }
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black87,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Tukangku Sekarang',
                      style: TextStyle(
                        color: Color(0xffe46b10),
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Proffesional Homecare',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent.shade700),
                            ),
                            fillColor: Color(0xfff3f3f4),
                            filled: true)),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            hintText: 'Nama Lengkap',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent.shade700),
                            ),
                            fillColor: Color(0xfff3f3f4),
                            filled: true)),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: _passwordController,
                        obscureText: showPassword,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                child: Icon(showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility)),
                            // border: InputBorder.none,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent.shade700),
                            ),
                            fillColor: Color(0xfff3f3f4),
                            filled: true)),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: _confirmPassController,
                        obscureText: showConfirmPass,
                        decoration: InputDecoration(
                            hintText: 'Konfirmasi Password',
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showConfirmPass = !showConfirmPass;
                                  });
                                },
                                child: Icon(showConfirmPass
                                    ? Icons.visibility_off
                                    : Icons.visibility)),
                            // border: InputBorder.none,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent.shade700),
                            ),
                            fillColor: Color(0xfff3f3f4),
                            filled: true)),
                    SizedBox(
                      height: 15,
                    ),
                    CheckboxListTile(
                      value: privacyCheck,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) {
                        setState(() {
                          privacyCheck = value!;
                        });
                      },
                      title: Text(
                        'I agree to terms of service and privacy policy',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () => _registerProcess(),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  offset: Offset(2, 4),
                                  blurRadius: 5,
                                  spreadRadius: 2)
                            ],
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.orangeAccent.shade700,
                                  Color(0xfff7892b)
                                ])),
                        child: Text(
                          'Register',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is RegisterLoading) {
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
