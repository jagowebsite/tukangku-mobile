import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: SingleChildScrollView(
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
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orangeAccent.shade700),
                      ),
                      fillColor: Color(0xfff3f3f4),
                      filled: true)),
              SizedBox(
                height: 10,
              ),
              TextField(
                  decoration: InputDecoration(
                      hintText: 'Nama Lengkap',
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orangeAccent.shade700),
                      ),
                      fillColor: Color(0xfff3f3f4),
                      filled: true)),
              SizedBox(
                height: 10,
              ),
              TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: Icon(Icons.visibility_off),
                      // border: InputBorder.none,
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orangeAccent.shade700),
                      ),
                      fillColor: Color(0xfff3f3f4),
                      filled: true)),
              SizedBox(
                height: 10,
              ),
              TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Konfirmasi Password',
                      suffixIcon: Icon(Icons.visibility_off),
                      // border: InputBorder.none,
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orangeAccent.shade700),
                      ),
                      fillColor: Color(0xfff3f3f4),
                      filled: true)),
              SizedBox(
                height: 15,
              ),
              CheckboxListTile(
                value: false,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {},
                title: Text(
                  'I agree to terms of service and privacy policy',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
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
              )
            ],
          ),
        ));
  }
}
