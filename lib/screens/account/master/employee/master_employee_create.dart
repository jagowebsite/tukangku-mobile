import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tukangku/blocs/employee_bloc/employee_bloc.dart';
import 'package:tukangku/models/category_service_model.dart';
import 'package:tukangku/models/employee_model.dart';
import 'package:tukangku/repositories/category_service_repository.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class MasterEmployeeCreate extends StatefulWidget {
  const MasterEmployeeCreate({Key? key}) : super(key: key);

  @override
  _MasterEmployeeCreateState createState() => _MasterEmployeeCreateState();
}

class _MasterEmployeeCreateState extends State<MasterEmployeeCreate> {
  CategoryServiceRepository _categoryServiceRepo = CategoryServiceRepository();
  late EmployeeBloc employeeBloc;

  TextEditingController nameController = TextEditingController();
  TextEditingController telpController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  File? imageFile;
  List<CategoryServiceModel> listCategories = [];
  CategoryServiceModel? categoryService;

  bool isReady = true;
  bool isActive = true;

  Future getCategoryService() async {
    List<CategoryServiceModel>? data =
        await _categoryServiceRepo.getCategoryServices();
    if (data != null) {
      listCategories = data;
      setState(() {});
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

  Future createEmployee() async {
    if (categoryService != null) {
      EmployeeModel employeeModel = EmployeeModel(
          name: nameController.text,
          number: telpController.text,
          address: addressController.text,
          status: isActive ? 'active' : 'inactive',
          isReady: isReady,
          imageFile: imageFile,
          categoryService: categoryService);
      employeeBloc.add(CreateEmployee(employeeModel));
    } else {
      CustomSnackbar.showSnackbar(
          context,
          'Silahkan masukkan kategori service terlebih dahulu',
          SnackbarType.warning);
    }
  }

  @override
  void initState() {
    employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    getCategoryService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<EmployeeBloc, EmployeeState>(
      listener: (context, state) {
        if (state is CreateEmployeeSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is CreateEmployeeError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Tambah Tukang',
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
                                'Data Tukang',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Nama Tukang'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Contoh: Sandono...'),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Nomor Telp'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              controller: telpController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Contoh: 0856663...'),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Alamat'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              controller: addressController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Contoh: Jl. Simpang lima...'),
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
                            ),
                          ),
                          Container(
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text('Is Ready'),
                              value: isReady,
                              onChanged: (value) {
                                setState(() {
                                  isReady = value!;
                                });
                              },
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
                                'Foto Tukang',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () => pickImage(),
                            child: Container(
                                width: size.width,
                                height: 50,
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
                          SizedBox(
                            height: 80,
                          )
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
                        onPressed: () => createEmployee(),
                        child: Text('Simpan',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ),
              BlocBuilder<EmployeeBloc, EmployeeState>(
                builder: (context, state) {
                  if (state is CreateEmployeeLoading) {
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
