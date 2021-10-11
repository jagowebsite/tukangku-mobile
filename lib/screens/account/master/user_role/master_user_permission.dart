import 'package:flutter/material.dart';

class MasterUserPermission extends StatefulWidget {
  const MasterUserPermission({Key? key}) : super(key: key);

  @override
  _MasterUserPermissionState createState() => _MasterUserPermissionState();
}

class _MasterUserPermissionState extends State<MasterUserPermission> {
  List<String> permissions = [
    'dashboard_view',
    'profile_view',
    'service_view',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Role Akses',
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
                  title: Container(
                    child: Text(
                      permissions[index],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  subtitle: Text('Web'),
                  trailing: Icon(Icons.chevron_right, color: Colors.black87),
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
