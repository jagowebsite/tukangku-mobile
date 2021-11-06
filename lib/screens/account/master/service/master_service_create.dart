import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tukangku/blocs/master_service_bloc/master_service_bloc.dart';
import 'package:tukangku/models/service_model.dart';

class MasterServiceCreate extends StatefulWidget {
  const MasterServiceCreate({Key? key}) : super(key: key);

  @override
  _MasterServiceCreateState createState() => _MasterServiceCreateState();
}

class _MasterServiceCreateState extends State<MasterServiceCreate> {
  late MasterServiceBloc masterServiceBloc;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isActive = true;
  String type = 'JAM';

  // List data
  List<File> images = [];

  // Load gambar property asset dari galery
  // List<File>
  Future<void> loadAssets() async {
    final pickedMultipleFile =
        await ImagePicker().pickMultiImage(maxWidth: 1280);
    List<File> files = [];
    if (pickedMultipleFile != null) {
      for (var i = 0; i < pickedMultipleFile.length; i++) {
        files.add(await FlutterExifRotation.rotateImage(
            path: pickedMultipleFile[i].path));
      }
    }
    images.addAll(files);
    setState(() {});
  }

  Future createService() async {
    ServiceModel serviceModel = ServiceModel(
        name: nameController.text,
        status: isActive ? 'active' : 'inactive',
        typeQuantity: type,
        price: int.parse(priceController.text),
        description: descriptionController.text,
        imageFiles: images);
    masterServiceBloc.add(CreateMasterService(serviceModel));
  }

  @override
  void initState() {
    masterServiceBloc = BlocProvider.of<MasterServiceBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Tambah Jasa',
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
                              'Data Service',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Nama Service'),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade100),
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Contoh: Service AC Baru...'),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Biaya Layanan'),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade100),
                          child: TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Contoh: 1000000...'),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Deskripsi Layanan'),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade100),
                          child: TextField(
                            controller: descriptionController,
                            textAlignVertical: TextAlignVertical.bottom,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            minLines: 3,
                            maxLines: 10,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Contoh: Service AC adalah...'),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text('Is Active'),
                          value: isActive,
                          onChanged: (value) {
                            setState(() {
                              isActive = value!;
                            });
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
                    width: size.width,
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Text(
                              'Foto Service',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: size.width,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.orangeAccent.shade700,
                                width: 1,
                              ),
                            ),
                            child: buildGridView()),
                        SizedBox(
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
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
                      onPressed: () => createService(),
                      child:
                          Text('Simpan', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
            BlocBuilder<MasterServiceBloc, MasterServiceState>(
              builder: (context, state) {
                if (state is CreateMasterServiceLoading) {
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
        ));
  }

  Widget buildGridView() {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      mainAxisSpacing: 10,
      crossAxisSpacing: 5,
      crossAxisCount: 3,
      children: List.generate(images.length + 1, (index) {
        if (index < images.length) {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.file(
                  images[index],
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                  child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  child: RawMaterialButton(
                    onPressed: () {
                      setState(() {
                        images.removeAt(index);
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    fillColor: Colors.red.shade700,
                    constraints: BoxConstraints(maxWidth: 30, maxHeight: 50),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    padding: EdgeInsets.all(1),
                    shape: CircleBorder(),
                  ),
                ),
              )),
            ],
          );
        } else {
          return GestureDetector(
            onTap: loadAssets,
            child: Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(right: 5, bottom: 5),
              color: Colors.grey.shade200,
              child: Center(
                child: Icon(Icons.add_circle, color: Colors.grey),
              ),
            ),
          );
        }
      }),
    );
  }
}
