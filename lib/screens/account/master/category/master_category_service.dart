import 'package:flutter/material.dart';

class MasterCategoryService extends StatefulWidget {
  const MasterCategoryService({Key? key}) : super(key: key);

  @override
  _MasterCategoryServiceState createState() => _MasterCategoryServiceState();
}

class _MasterCategoryServiceState extends State<MasterCategoryService> {
  List<String> categories = [
    'Bebersih',
    'Service AC',
    'Pertukangan',
    'Listrik'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Kategori Jasa',
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
            child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {},
                    leading: Container(
                      decoration: BoxDecoration(
                          color: Colors.orange, shape: BoxShape.circle),
                      child: Container(
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage('https://picsum.photos/64'),
                        ),
                      ),
                    ),
                    title: Container(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right, color: Colors.black87),
                  );
                })));
  }
}
