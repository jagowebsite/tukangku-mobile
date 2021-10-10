import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profil',
            style: TextStyle(color: Colors.black87),
          ),
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage('https://i.pravatar.cc/300'),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Boy William',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'boywilliam@gmai.cmo',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Data Pribadi',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      minVerticalPadding: 0,
                      onTap: () =>
                          Navigator.of(context).pushNamed('/update-profile'),
                      title: Text('Update Profil'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    ListTile(
                      title: Text('Ubah Password'),
                      onTap: () =>
                          Navigator.of(context).pushNamed('/update-password'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Transaksi',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      title: Text('Keranjang'),
                      onTap: () => Navigator.of(context).pushNamed('/cart'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    ListTile(
                      title: Text('Semua Transaksi'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Data Master',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      minVerticalPadding: 0,
                      onTap: () =>
                          Navigator.of(context).pushNamed('/master-service'),
                      title: Text('Data Jasa'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    ListTile(
                      onTap: () => Navigator.of(context)
                          .pushNamed('/master-service-category'),
                      title: Text('Data Kategori Jasa'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    ListTile(
                      onTap: () =>
                          Navigator.of(context).pushNamed('/master-employee'),
                      title: Text('Data Tukang'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    ListTile(
                      onTap: () =>
                          Navigator.of(context).pushNamed('/master-banner'),
                      title: Text('Data Banner'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Pendaftaran Konsumen',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      minVerticalPadding: 0,
                      onTap: () {},
                      title: Text('Data Pendaftaran Konsumen'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Data Management User',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      minVerticalPadding: 0,
                      onTap: () {},
                      title: Text('Data User'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    ListTile(
                      title: Text('User Log'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    ListTile(
                      title: Text('Role Akses'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Pembeli / Konsumen',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      minVerticalPadding: 0,
                      onTap: () {},
                      title: Text('View User Pembeli'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    ListTile(
                      title: Text('Transaksi Pembeli'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    ListTile(
                      title: Text('Log GPS Pembeli'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: size.width,
                        height: 40,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.orangeAccent.shade700),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text('Logout',
                              style: TextStyle(
                                color: Colors.orangeAccent.shade700,
                                fontSize: 18,
                              )),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
        ));
  }
}
