import 'package:flutter/material.dart';

class MasterGPSLog extends StatefulWidget {
  const MasterGPSLog({Key? key}) : super(key: key);

  @override
  _MasterGPSLogState createState() => _MasterGPSLogState();
}

class _MasterGPSLogState extends State<MasterGPSLog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Log GPS Pembeli',
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
                      'Jalan HR muhammad No. 373',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  isThreeLine: true,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('-7.2849482571831015'),
                      Text(
                        '112.69343853960775',
                      ),
                      Text(
                        'Invoice : TK74867833',
                        style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.location_on, color: Colors.red),
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
