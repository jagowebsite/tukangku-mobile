import 'package:flutter/material.dart';

class MasterBanner extends StatefulWidget {
  const MasterBanner({Key? key}) : super(key: key);

  @override
  _MasterBannerState createState() => _MasterBannerState();
}

class _MasterBannerState extends State<MasterBanner> {
  List<String> banners = [
    'Opening Tukangku Apps',
    'Pilih Jasa Idamanmu Sekarang',
    'Jasa Serba Bisa'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Master Data Banner',
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
                    child: Container(
                      child: ClipRRect(
                        child: Image.network('https://picsum.photos/64'),
                      ),
                    ),
                  ),
                  title: Container(
                    child: Text(
                      banners[index],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  subtitle: Text('Aktif'),
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
