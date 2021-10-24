import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:tukangku/models/login_model.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VerifyEmailScreen extends StatefulWidget {
  final LoginModel? loginModel;
  const VerifyEmailScreen({Key? key, this.loginModel}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  AuthRepository _authRepo = AuthRepository();
  TextEditingController usernameController = TextEditingController();

  Future resendVerifyEmail() async {
    EasyLoading.show(status: 'loading...');
    ResponseModel? responseModel =
        await _authRepo.resendVerifyEmail(usernameController.text);
    EasyLoading.dismiss();
    if (responseModel != null) {
      if (responseModel.status == 'success') {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: responseModel.message,
        );
      } else {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          text: responseModel.message,
        );
      }
    }
  }

  @override
  void initState() {
    usernameController.text = widget.loginModel!.username ?? '';
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verifikasi Email',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black87),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
                'Kirim ulang verifikasi email apabila kamu belum menerima link verifikasi di email kamu.'),
            SizedBox(
              height: 10,
            ),
            TextField(
                controller: usernameController,
                obscureText: false,
                decoration: InputDecoration(
                    hintText: 'Email',
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.orangeAccent.shade700),
                    ),
                    fillColor: Color(0xfff3f3f4),
                    filled: true)),
            SizedBox(
              height: 15,
            ),
            Container(
              width: size.width,
              child: TextButton(
                onPressed: () => resendVerifyEmail(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Kirim Ulang',
                      style: TextStyle(color: Colors.white)),
                ),
                style:
                    TextButton.styleFrom(backgroundColor: Colors.orangeAccent),
              ),
            )
          ],
        ),
      ),
    );
  }
}
