import 'package:flutter/material.dart';

class MasterUserPermissionEdit extends StatefulWidget {
  const MasterUserPermissionEdit({Key? key}) : super(key: key);

  @override
  _MasterUserPermissionEditState createState() =>
      _MasterUserPermissionEditState();
}

class _MasterUserPermissionEditState extends State<MasterUserPermissionEdit> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Update Permission',
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
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  width: size.width,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            'Data Permission',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Nama Permission'),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100),
                        child: TextField(
                          // controller: _bannerNameController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Contoh: Admin...'),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Guard Name'),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100),
                        child: TextField(
                          // controller: _urlBannerController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Contoh: Web, Api...'),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 7,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Container(
                        color: Colors.red.shade500,
                        child: TextButton(
                          onPressed: () => {},
                          child: Text('Delete',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 7,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Container(
                        color: Colors.orangeAccent.shade700,
                        child: TextButton(
                          onPressed: () => {},
                          child: Text('Update',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // BlocBuilder<BannerBloc, BannerState>(
          //   builder: (context, state) {
          //     if (state is CreateBannerLoading) {
          //       return Container(
          //           color: Colors.white.withOpacity(0.5),
          //           child: Center(
          //             child: Container(
          //                 width: 25,
          //                 height: 25,
          //                 child: CircularProgressIndicator(
          //                   color: Colors.orangeAccent.shade700,
          //                   strokeWidth: 3,
          //                 )),
          //           ));
          //     } else {
          //       return Container();
          //     }
          //   },
          // )
        ],
      ),
    );
  }
}
