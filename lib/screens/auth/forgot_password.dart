import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  AuthRepository authRepo = AuthRepository();

  TextEditingController emailController = TextEditingController();

  Future sendForgotPassword() async {
    EasyLoading.show(status: 'Loading', dismissOnTap: true);
    if (emailController.text == '') {
          CustomSnackbar.showSnackbar(
              context, 'Mohon masukkan email anda yang sudah terdaftar', SnackbarType.warning);
    } else {
      ResponseModel? response =
          await authRepo.forgotPassword(emailController.text);
          
    EasyLoading.dismiss();
      if (response != null) {
        if (response.status == 'success') {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: response.message!,
          );
        } else {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.warning,
            text: response.message!,
          );
        }
      }
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Forgot Password',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.chevron_left,
              color: Colors.black,
              size: 30,
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Masukkan email anda'),
                          SizedBox(height: 5,),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Masukkan email anda...'
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            'Kami akan mengirim link untuk reset password ke email akun anda.',
                          )
                        ],
                      )),
                ],
              ),
            ),
            Positioned(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: ShapeDecoration(
                    shape: StadiumBorder(),
                    color: Colors.orange.shade700,
                  ),
                  child: MaterialButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: StadiumBorder(),
                    child: Text(
                      'Kirim',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () => sendForgotPassword(),
                  )),
            ))
          ],
        ));
  }
}
