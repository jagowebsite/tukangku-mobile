import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/auth_bloc/auth_bloc.dart';
import 'package:tukangku/main.dart';
import 'package:tukangku/screens/widgets/bottom_sheet_modal.dart';
import 'package:tukangku/screens/widgets/custom_cached_image.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late AuthBloc authBloc;

  Future logout() async {
    BottomSheetModal.show(context, children: [
      const Text('Apakah kamu yakin ingin keluar?'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(primary: Colors.orangeAccent.shade700),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
            onPressed: () => authBloc.add(Logout()),
          ),
        ],
      ),
    ]);
  }

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(GetAuthData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          // Navigator.of(context).popAndPushNamed('/');
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => MyHomePage()),
            ModalRoute.withName('/'),
            // (route) => false
          );
        }
      },
      child: Scaffold(
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
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return Container(
                                width: 45,
                                height: 45,
                                child: ClipOval(
                                  child: CircleAvatar(
                                    child: CustomCachedImage.build(context,
                                        imgUrl: state is Authorized
                                            ? (state.user.images ??
                                                'https://i.pravatar.cc/300')
                                            : 'https://i.pravatar.cc/300'),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state is Authorized
                                        ? (state.user.name ?? 'Hai,')
                                        : 'Hai,',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    state is Authorized
                                        ? (state.user.email ?? 'Lagi Cari Apa?')
                                        : 'Lagi Cari Apa?',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              );
                            },
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
                            onTap: () => Navigator.of(context)
                                .pushNamed('/update-profile'),
                            title: Text('Update Profil'),
                            trailing: Icon(Icons.chevron_right),
                          ),
                          Divider(
                            thickness: 0.5,
                          ),
                          ListTile(
                            title: Text('Ubah Password'),
                            onTap: () => Navigator.of(context)
                                .pushNamed('/update-password'),
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
                            onTap: () =>
                                Navigator.of(context).pushNamed('/cart'),
                            trailing: Icon(Icons.chevron_right),
                          ),
                          Divider(
                            thickness: 0.5,
                          ),
                          ListTile(
                            onTap: () => Navigator.of(context)
                                .pushNamed('/my-transaction'),
                            title: Text('Semua Transaksi'),
                            trailing: Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is Authorized) {
                          if (state.user.roleAccessModel!.name ==
                              'superadmin') {
                            return Column(
                              children: [
                                Container(
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'Data Master',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      ListTile(
                                        minVerticalPadding: 0,
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/master-service'),
                                        title: Text('Data Jasa'),
                                        trailing: Icon(Icons.chevron_right),
                                      ),
                                      Divider(
                                        thickness: 0.5,
                                      ),
                                      ListTile(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed(
                                                '/master-service-category'),
                                        title: Text('Data Kategori Jasa'),
                                        trailing: Icon(Icons.chevron_right),
                                      ),
                                      Divider(
                                        thickness: 0.5,
                                      ),
                                      ListTile(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/master-employee'),
                                        title: Text('Data Tukang'),
                                        trailing: Icon(Icons.chevron_right),
                                      ),
                                      Divider(
                                        thickness: 0.5,
                                      ),
                                      ListTile(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/master-banner'),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'Pendaftaran Konsumen',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      ListTile(
                                        minVerticalPadding: 0,
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/master-consumen'),
                                        title:
                                            Text('Data Pendaftaran Konsumen'),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'Data Management User',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      ListTile(
                                        minVerticalPadding: 0,
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/master-user'),
                                        title: Text('Data User'),
                                        trailing: Icon(Icons.chevron_right),
                                      ),
                                      Divider(
                                        thickness: 0.5,
                                      ),
                                      ListTile(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/master-user-log'),
                                        title: Text('User Log'),
                                        trailing: Icon(Icons.chevron_right),
                                      ),
                                      Divider(
                                        thickness: 0.5,
                                      ),
                                      ListTile(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/master-user-role'),
                                        title: Text('Role Akses'),
                                        trailing: Icon(Icons.chevron_right),
                                      ),
                                      Divider(
                                        thickness: 0.5,
                                      ),
                                      ListTile(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed(
                                                '/master-user-permission'),
                                        title: Text('Permission'),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'Pembeli / Konsumen',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      ListTile(
                                        minVerticalPadding: 0,
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/master-transaction'),
                                        title: Text('View User Pembeli'),
                                        trailing: Icon(Icons.chevron_right),
                                      ),
                                      Divider(
                                        thickness: 0.5,
                                      ),
                                      ListTile(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/master-payment'),
                                        title: Text('Transaksi Pembeli'),
                                        trailing: Icon(Icons.chevron_right),
                                      ),
                                      Divider(
                                        thickness: 0.5,
                                      ),
                                      ListTile(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/master-gps-log'),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'Laporan',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      ListTile(
                                        minVerticalPadding: 0,
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/report-service'),
                                        title: Text('Laporan Jasa'),
                                        trailing: Icon(Icons.chevron_right),
                                      ),
                                      Divider(
                                        thickness: 0.5,
                                      ),
                                      ListTile(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/report-all'),
                                        title: Text('Laporan Seluruh Penjual'),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'History',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      ListTile(
                                        minVerticalPadding: 0,
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/history-employee'),
                                        title: Text('History Pekerjaan Tukang'),
                                        trailing: Icon(Icons.chevron_right),
                                      ),
                                      Divider(
                                        thickness: 0.5,
                                      ),
                                      ListTile(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/history-consumen'),
                                        title: Text('History Orderan Konsumen'),
                                        trailing: Icon(Icons.chevron_right),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () => logout(),
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: size.width,
                                height: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.orangeAccent.shade700),
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
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is LoginLoading || state is LogoutLoading) {
                    return Container(
                        color: Colors.white.withOpacity(0.5),
                        child: Center(
                          child: Container(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                color: Colors.orangeAccent.shade700,
                                strokeWidth: 3,
                              )),
                        ));
                  } else {
                    return Container();
                  }
                },
              )
            ],
          )),
    );
  }
}
