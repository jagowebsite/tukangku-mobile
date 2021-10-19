import 'package:flutter/material.dart';

class MasterTransaction extends StatefulWidget {
  const MasterTransaction({Key? key}) : super(key: key);

  @override
  _MasterTransactionState createState() => _MasterTransactionState();
}

class _MasterTransactionState extends State<MasterTransaction> {
  List<String> permissions = [
    'IV8934729343',
    'IV8934729343',
    'IV8934729343',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'View User Pembeli',
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
                  onTap: () => Navigator.of(context)
                      .pushNamed('/master-transaction-detail'),
                  isThreeLine: true,
                  leading: Icon(Icons.receipt),
                  title: Container(
                    child: Text(
                      '${permissions[index]} - Haikal akbar sutijo',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Service AC Rumah'),
                      Text('Bebersih Rumah'),
                      Text(
                        'Rp 100.000',
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      Text('Selesai'),
                      Icon(Icons.check_circle_outline,
                          color: Colors.green.shade600),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 0.3,
                );
              },
              itemCount: permissions.length),
        ));
  }
}
