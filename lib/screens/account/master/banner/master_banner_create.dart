import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tukangku/blocs/banner_bloc/banner_bloc.dart';
import 'package:tukangku/models/banner_model.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class MasterBannerCreate extends StatefulWidget {
  const MasterBannerCreate({Key? key}) : super(key: key);

  @override
  _MasterBannerCreateState createState() => _MasterBannerCreateState();
}

class _MasterBannerCreateState extends State<MasterBannerCreate> {
  late BannerBloc bannerBloc;

  TextEditingController _bannerNameController = TextEditingController();
  TextEditingController _urlBannerController = TextEditingController();

  bool isActive = true;
  File? imageFile;

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      setState(() {});
    }
  }

  Future createBanner() async {
    if (imageFile == null ||
        _bannerNameController.text == '' ||
        _urlBannerController.text == '') {
      CustomSnackbar.showSnackbar(
          context, 'Pastikan semua input sudah diisi', SnackbarType.error);
    } else {
      BannerModel bannerModel = BannerModel(
          name: _bannerNameController.text,
          urlAsset: _urlBannerController.text,
          isActive: isActive,
          imageFile: imageFile);
      bannerBloc.add(CreateBanner(bannerModel));
    }
  }

  @override
  void initState() {
    bannerBloc = BlocProvider.of<BannerBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<BannerBloc, BannerState>(
      listener: (context, state) {
        if (state is CreateBannerSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is CreateBannerError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Tambah Banner',
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
                                'Data Banner',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Nama Banner'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              controller: _bannerNameController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      'Contoh: Diskon 10% Untuk Service...'),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('URL Banner'),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: TextField(
                              controller: _urlBannerController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      'Contoh: https://tukangku.co.id...'),
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
                                'Foto Banner',
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
                                padding: EdgeInsets.all(5),
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
                        onPressed: () => createBanner(),
                        child: Text('Simpan',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ),
              BlocBuilder<BannerBloc, BannerState>(
                builder: (context, state) {
                  if (state is CreateBannerLoading) {
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
