import 'package:flutter/material.dart';
import 'package:tukangku/screens/widgets/input_text.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  hintText: 'Password Sekarang',
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                InputText(
                  hintText: 'Password Baru',
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                InputText(
                  hintText: 'Konfirmasi Password',
                  obscureText: true,
                ),
              ],
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
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
          )
        ],
      ),
    );
  }
}
