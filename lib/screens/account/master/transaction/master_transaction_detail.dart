import 'package:flutter/material.dart';

class MasterTransactionDetail extends StatefulWidget {
  const MasterTransactionDetail({Key? key}) : super(key: key);

  @override
  _MasterTransactionDetailState createState() =>
      _MasterTransactionDetailState();
}

class _MasterTransactionDetailState extends State<MasterTransactionDetail> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Detail User Pembeli',
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
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3,
                          offset: Offset(0, 1))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Konsumen',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
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
                          'Aldebaran',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      subtitle: Text('rudi@gmail.com'),
                      trailing:
                          Icon(Icons.chevron_right, color: Colors.black87),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: size.width,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3,
                          offset: Offset(0, 1))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Konfirmasi Transaksi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
                        title: Text('Service AC - Bebersih'),
                        subtitle: Text('Pending',
                            style: TextStyle(color: Colors.orange)),
                        isThreeLine: true,
                        leading: Icon(Icons.close),
                        trailing: Icon(Icons.check_circle)),
                    ListTile(
                        title: Text('Service AC - Bebersih'),
                        subtitle: Text(
                          'Selesai',
                          style: TextStyle(color: Colors.green),
                        ),
                        isThreeLine: true,
                        leading: Icon(Icons.close),
                        trailing: Icon(Icons.more_horiz)),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: size.width,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3,
                          offset: Offset(0, 1))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bukti Pembayaran Transaksi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
                        title: Text('4544859473'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('19 October 2021'),
                            Text('Lunas',
                                style: TextStyle(color: Colors.orange)),
                          ],
                        ),
                        // isThreeLine: true,
                        leading: Container(
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network('https://picsum.photos/64'),
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                        title: Text('4544859473'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('19 October 2021'),
                            Text('Lunas',
                                style: TextStyle(color: Colors.orange)),
                          ],
                        ),
                        // isThreeLine: true,
                        leading: Container(
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network('https://picsum.photos/64'),
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: size.width,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3,
                          offset: Offset(0, 1))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Summary',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Invoice')),
                        Text('8734J83493')
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Tanggal')),
                        Text('02-02-2021')
                      ],
                    ),
                    Divider(
                      thickness: 0.4,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Service Ac @1')),
                        Text('Rp 100.000')
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text('Bersih Bersih - Mengepel Rumah @1')),
                        Text('Rp 130.000')
                      ],
                    ),
                    Divider(
                      thickness: 0.4,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Text(
                          'Rp 230.000',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red.shade600),
                      onPressed: () {},
                      child: Text('Batalkan',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.green.shade600),
                      onPressed: () {},
                      child: Text('Konfirmasi',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
