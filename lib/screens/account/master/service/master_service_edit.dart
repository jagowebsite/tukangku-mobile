import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tukangku/blocs/master_service_bloc/master_service_bloc.dart';
import 'package:tukangku/models/category_service_model.dart';
import 'package:tukangku/models/service_model.dart';
import 'package:tukangku/repositories/category_service_repository.dart';
import 'package:tukangku/screens/widgets/bottom_sheet_modal.dart';
import 'package:tukangku/utils/custom_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class MasterServiceEdit extends StatefulWidget {
  final ServiceModel serviceModel;
  const MasterServiceEdit({Key? key, required this.serviceModel})
      : super(key: key);

  @override
  _MasterServiceEditState createState() => _MasterServiceEditState();
}

class _MasterServiceEditState extends State<MasterServiceEdit> {
  CategoryServiceRepository _categoryServiceRepo = CategoryServiceRepository();
  late MasterServiceBloc masterServiceBloc;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isActive = true;

  List<String> listTypeServices = ['JAM', 'LAYANAN', 'HARI'];
  String? typeService;
  List<CategoryServiceModel> listCategories = [];
  CategoryServiceModel? categoryService;

  // List data
  List<File> images = [];

  Future getCategoryService() async {
    List<CategoryServiceModel>? data =
        await _categoryServiceRepo.getCategoryServices();
    if (data != null) {
      listCategories = data;
      setState(() {});
    }
  }

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

  Future updateService() async {
    if (nameController.text == '' ||
        priceController.text == '' ||
        descriptionController.text == '' ||
        typeService == null ||
        categoryService == null) {
      CustomSnackbar.showSnackbar(
          context, 'Pastikan semua input sudah diisi', SnackbarType.error);
    } else if (images.length == 0) {
      CustomSnackbar.showSnackbar(context,
          'Silahkan masukkan foto property terlebih dulu', SnackbarType.error);
    } else {
      ServiceModel serviceModel = ServiceModel(
          id: widget.serviceModel.id,
          name: nameController.text,
          categoryService: categoryService,
          status: isActive ? 'active' : 'inactive',
          typeQuantity: (typeService ?? '').toUpperCase(),
          price: int.parse(priceController.text),
          description: descriptionController.text,
          imageFiles: images);
      masterServiceBloc.add(UpdateServiceMaster(serviceModel));
    }
  }

  Future deleteService() async {
    ServiceModel serviceModel = ServiceModel(id: widget.serviceModel.id);
    BottomSheetModal.show(context, children: [
      const Text('Apakah kamu yakin ingin menghapus?'),
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
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
            onPressed: () {
              masterServiceBloc.add(DeleteServiceMaster(serviceModel));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ]);
  }

  Future urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    images.add(file);

    setState(() {});
  }

  Future initValue() async {
    nameController.text = widget.serviceModel.name ?? '';
    descriptionController.text = widget.serviceModel.description ?? '';
    priceController.text = widget.serviceModel.price != null
        ? widget.serviceModel.price.toString()
        : '';
    isActive = widget.serviceModel.status == 'active' ? true : false;
    typeService = (widget.serviceModel.typeQuantity ?? '').toUpperCase();

    await getCategoryService();
    for (var i = 0; i < listCategories.length; i++) {
      if (listCategories[i].id == widget.serviceModel.categoryService!.id) {
        categoryService = listCategories[i];
      }
    }

    if (widget.serviceModel.images != null) {
      for (var i = 0; i < widget.serviceModel.images!.length; i++) {
        urlToFile(widget.serviceModel.images![i]);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    masterServiceBloc = BlocProvider.of<MasterServiceBloc>(context);
    initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<MasterServiceBloc, MasterServiceState>(
      listener: (context, state) {
        if (state is UpdateMasterServiceSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is UpdateMasterServiceError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        } else if (state is DeleteMasterServiceSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is DeleteMasterServiceError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Edit Jasa',
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
                          Text('Kategori Service'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: DropdownButton<CategoryServiceModel>(
                              dropdownColor: Colors.grey.shade100,
                              value: categoryService,
                              isExpanded: true,
                              icon: Icon(Icons.expand_more),
                              iconSize: 24,
                              elevation: 1,
                              style: TextStyle(color: Colors.black),
                              underline: Container(),
                              onChanged: (CategoryServiceModel? newValue) {
                                setState(() {
                                  categoryService = newValue!;
                                });
                              },
                              items: listCategories
                                  .map((CategoryServiceModel value) {
                                return DropdownMenuItem<CategoryServiceModel>(
                                  value: value,
                                  child: Text(value.name!),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Tipe Service'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: DropdownButton<String>(
                              dropdownColor: Colors.grey.shade100,
                              value: typeService,
                              isExpanded: true,
                              icon: Icon(Icons.expand_more),
                              iconSize: 24,
                              elevation: 1,
                              style: TextStyle(color: Colors.black),
                              underline: Container(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  typeService = newValue!;
                                });
                              },
                              items: listTypeServices.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
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
                              onPressed: () => deleteService(),
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
                              onPressed: () => updateService(),
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
              BlocBuilder<MasterServiceBloc, MasterServiceState>(
                builder: (context, state) {
                  if (state is UpdateMasterServiceLoading ||
                      state is DeleteMasterServiceLoading) {
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
