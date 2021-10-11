import 'package:flutter/material.dart';

class MasterUserLog extends StatefulWidget {
  const MasterUserLog({Key? key}) : super(key: key);

  @override
  _MasterUserLogState createState() => _MasterUserLogState();
}

class _MasterUserLogState extends State<MasterUserLog> {
  List<String> users = [
    'Rudi Hariono',
    'Andi Suhadi',
    'Sri Rahayu',
    'Jajang Hermansyah'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'User Log',
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
        body: Container(
          child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {},
                  title: Container(
                    child: Text(
                      users[index],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('rudi@gmail.com'),
                      Text('Menambahkan transaksi baru'),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      Text('17-09-2021'),
                      Text('02:45:00'),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 0.3,
                );
              },
              itemCount: 3),
        ));
  }
}
