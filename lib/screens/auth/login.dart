import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/auth_bloc/auth_bloc.dart';
import 'package:tukangku/models/login_model.dart';
import 'package:tukangku/models/user_model.dart';
import 'package:tukangku/screens/account/profile/update_profile.dart';
import 'package:tukangku/screens/auth/verify_email.dart';
import 'package:tukangku/screens/navbar.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController =
      TextEditingController(text: 'harmokobaf@gmail.com');
  TextEditingController passwordController =
      TextEditingController(text: 'admin');

  late AuthBloc authBloc;

  bool passwordObscure = true;

  Future loginProcess() async {
    if (usernameController.text == '' || passwordController.text == '') {
      String message = 'Username atau password tidak boleh ada yang kosong!';
      CustomSnackbar.showSnackbar(context, message, SnackbarType.warning);
    } else {
      LoginModel loginModel = new LoginModel(
          username: usernameController.text, password: passwordController.text);
      authBloc.add(LoginProcess(loginModel));
    }
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () => loginProcess(),
      // onTap: () => Navigator.of(context).pushNamed('/navbar'),
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
                colors: [Colors.orangeAccent.shade700, Color(0xfff7892b)])),
        child: Text(
          'Sign In',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/register').then(onGoBack),
      child: Container(
        // margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(5),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _forgotPasswordLabel() {
    return InkWell(
      onTap: () =>
          Navigator.of(context).pushNamed('/forgot-password').then(onGoBack),
      child: Container(
        // margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(5),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Forgot password?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Click here',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: '',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'Tukang',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
            TextSpan(
              text: 'ku',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        TextField(
            controller: usernameController,
            obscureText: false,
            decoration: InputDecoration(
                hintText: 'Username',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent.shade700),
                ),
                fillColor: Color(0xfff3f3f4),
                filled: true)),
        SizedBox(
          height: 15,
        ),
        TextField(
            controller: passwordController,
            obscureText: passwordObscure,
            decoration: InputDecoration(
                hintText: 'Password',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent.shade700),
                ),
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        passwordObscure = !passwordObscure;
                      });
                    },
                    child: passwordObscure
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility)),
                fillColor: Color(0xfff3f3f4),
                filled: true)),
      ],
    );
  }

  /// Merefresh data ketika kembali ke page ini (current page)
  /// Mencegah perbedaan state dalam satu bloc
  FutureOr onGoBack(dynamic value) {
    print('iam on goback...');
    authBloc.add(GetAuthData());
  }

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(GetAuthData());
    super.initState();
  }

  bool validation(User user) {
    if (user.name == '' ||
        user.address == '' ||
        user.ktpImage == '' ||
        user.dateOfBirth == '' ||
        user.number == '') {
      return false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    // usernameController.dispose();
    // passwordController.dispose();
    // authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = MediaQuery.of(context).size.height;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is VerifyEmail) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return VerifyEmailScreen(
              loginModel: state.loginModel,
            );
          })).then(onGoBack);
        } else if (state is LoginSuccess || state is Authorized) {
          // Navigator.of(context).popAndPushNamed('/navbar');
          if (state is LoginSuccess) {
            if (validation(state.user)) {
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => const Navbar()),
                ModalRoute.withName('/navbar'),
              );
            } else {
              CustomSnackbar.showSnackbar(
                  context,
                  'Mohon lengkapi data anda terlebih dahulu',
                  SnackbarType.warning);
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => const UpdateProfil(
                          isInit: true,
                        )),
                ModalRoute.withName('/update-profile'),
              );
            }
          }
        } else if (state is LoginError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black87,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Container(
                height: height,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                height: size.width * 0.3,
                                child: Image.asset(
                                    'assets/logo/tukangku_logo.png')),
                            _title(),
                            Text('Proffesional Homecare'),
                            SizedBox(
                              height: 20,
                            ),
                            _emailPasswordWidget(),
                            SizedBox(
                              height: 25,
                            ),
                            _submitButton(),
                            SizedBox(
                              height: 30,
                            ),
                            _divider(),
                            SizedBox(
                              height: 10,
                            ),
                            _createAccountLabel(),
                            _forgotPasswordLabel()
                          ],
                        ),
                      ),
                    ),
                    // Positioned(
                    //     child: Align(
                    //         alignment: Alignment.bottomCenter,
                    //         child: Container(
                    //             height: 70, child: _forgotPasswordLabel())))
                  ],
                ),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is LoginLoading) {
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
