import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 100, child: Image.asset('assets/flats/chat-flat.png')),
            SizedBox(
              height: 15,
            ),
            Text(
              'We are coming soon!',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
