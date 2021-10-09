import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UpdateProfil extends StatefulWidget {
  const UpdateProfil({Key? key}) : super(key: key);

  @override
  _UpdateProfilState createState() => _UpdateProfilState();
}

class _UpdateProfilState extends State<UpdateProfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Update Profil',
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    child: GestureDetector(
                      onTap: () {},
                      child: Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            child: CircleAvatar(
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade700,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  imageUrl: 'https://i.pravatar.cc/300',
                                  placeholder: (context, url) => Container(
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade200,
                                      highlightColor: Colors.grey.shade300,
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  // placeholder: (context, url) =>
                                  //     CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                          height: 80,
                                          width: 80,
                                          child: Icon(Icons.account_circle,
                                              size: 50)),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              child: Align(
                            alignment: Alignment.bottomRight,
                            child: ClipOval(
                              child: Container(
                                width: 20,
                                height: 20,
                                color: Colors.black87,
                                child: Icon(Icons.camera_alt,
                                    size: 15, color: Colors.white),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  decoration:
                      InputDecoration(hintText: 'Email', enabled: false),
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Nama Lengkap'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Tanggal Lahir'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'No Telp'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Alamat'),
                ),
              ],
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(15),
                color: Colors.white,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.orangeAccent.shade700),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text('Update',
                          style: TextStyle(
                            color: Colors.orangeAccent.shade700,
                            fontSize: 18,
                          )),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
