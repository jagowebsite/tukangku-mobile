import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/auth_bloc/auth_bloc.dart';
import 'package:tukangku/screens/auth/verify_email.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late AuthBloc authBloc;

  bool passwordObscure = true;

  Future loginProcess() async {
    // LoginModel loginModel = new LoginModel(
    //     username: usernameController.text, password: passwordController.text);
    // authBloc.add(LoginProcess(loginModel));
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const VerifyEmailScreen();
    }));

    // authBloc.add(GetAuthData());
    authBloc.add(OnLogout());
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () => loginProcess(),
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
      onTap: () => Navigator.of(context).pushNamed('/register'),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
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

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
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
        body: Container(
          height: height,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(height: height * .2),
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
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
        ));
  }
}
