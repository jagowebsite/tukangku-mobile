import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 25,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.black87,
          icon: Icon(Icons.arrow_back),
        ),
        title: Container(
            height: 40,
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Expanded(
                child: TextField(
                  textAlignVertical: TextAlignVertical.bottom,
                  maxLines: 1,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) =>
                      Navigator.of(context).pushNamed('/services'),
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.only(left: 10, top: 6, bottom: 11),
                      hintText: 'Cari layanan disini...',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        size: 25,
                        color: Colors.grey,
                      )),
                ),
              ),
            ])),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Container(
              color: Colors.white,
              width: size.width,
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text('Pertukangan'),
                  ),
                  Divider(
                    // height: 3,
                    thickness: 0.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text('Bebersih'),
                  ),
                  Divider(
                    // height: 3,
                    thickness: 0.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text('Barang'),
                  ),
                  Divider(
                    // height: 3,
                    thickness: 0.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text('Desain'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
