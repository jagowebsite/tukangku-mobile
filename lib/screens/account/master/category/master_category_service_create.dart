import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tukangku/blocs/category_service_bloc/category_service_bloc.dart';
import 'package:tukangku/models/category_service_model.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class MasterCategoryServiceCreate extends StatefulWidget {
  const MasterCategoryServiceCreate({Key? key}) : super(key: key);

  @override
  _MasterCategoryServiceCreateState createState() =>
      _MasterCategoryServiceCreateState();
}

class _MasterCategoryServiceCreateState
    extends State<MasterCategoryServiceCreate> {
  late CategoryServiceBloc categoryServiceBloc;
  TextEditingController nameController = TextEditingController();
  File? imageFile;

  Future createCategoryService() async {
    if (nameController.text == '' || imageFile == null) {
      CustomSnackbar.showSnackbar(
          context, 'Pastikan semua masukan sudah terisi', SnackbarType.warning);
    } else {
      CategoryServiceModel categoryServiceModel =
          CategoryServiceModel(name: nameController.text, imageFile: imageFile);
      categoryServiceBloc.add(CreateServiceCategory(categoryServiceModel));
    }
  }

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      setState(() {});
    }
  }

  @override
  void initState() {
    categoryServiceBloc = BlocProvider.of<CategoryServiceBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<CategoryServiceBloc, CategoryServiceState>(
      listener: (context, state) {
        if (state is CreateCategoryServiceSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is CreateCategoryServiceError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Tambah Kategori Service',
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
                                'Data Kategori',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Nama Kategori'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Contoh: Bebersih...'),
                            ),
                          ),
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
                                'Icon Kategori',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () => pickImage(),
                            child: Container(
                                width: size.width,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.orangeAccent.shade700,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                    child: imageFile == null
                                        ? Text('+ Pilih Foto',
                                            style: TextStyle(
                                                color: Colors
                                                    .orangeAccent.shade700))
                                        : Container(
                                            child: Image.file(imageFile!),
                                          ))),
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
                        onPressed: () => createCategoryService(),
                        child: Text('Simpan',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ),
              BlocBuilder<CategoryServiceBloc, CategoryServiceState>(
                builder: (context, state) {
                  if (state is CreateCategoryServiceLoading) {
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
