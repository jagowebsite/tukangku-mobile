import 'package:flutter/material.dart';

class MasterEmployee extends StatefulWidget {
  const MasterEmployee({Key? key}) : super(key: key);

  @override
  _MasterEmployeeState createState() => _MasterEmployeeState();
}

class _MasterEmployeeState extends State<MasterEmployee> {
  List<String> employees = [
    'Pak Budi',
    'Andriono Sujiwo',
    'Lukito Muldoko',
    'Sudijo Buwono'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Master Data Tukang',
              style: TextStyle(color: Colors.black87),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add,
                  color: Colors.black87,
                ),
              )
            ],
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
                  leading: Container(
                    decoration: BoxDecoration(
                        color: Colors.orange, shape: BoxShape.circle),
                    child: Container(
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage('https://i.pravatar.cc/300'),
                      ),
                    ),
                  ),
                  title: Container(
                    child: Text(
                      employees[index],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  subtitle: Text('Bebersih'),
                  trailing: Icon(Icons.chevron_right, color: Colors.black87),
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