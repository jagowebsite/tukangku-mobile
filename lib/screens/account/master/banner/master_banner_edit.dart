import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tukangku/blocs/banner_bloc/banner_bloc.dart';
import 'package:tukangku/models/banner_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:tukangku/screens/widgets/bottom_sheet_modal.dart';
import 'package:tukangku/utils/custom_snackbar.dart';

class MasterBannerEdit extends StatefulWidget {
  final BannerModel bannerModel;
  const MasterBannerEdit({Key? key, required this.bannerModel})
      : super(key: key);

  @override
  _MasterBannerEditState createState() => _MasterBannerEditState();
}

class _MasterBannerEditState extends State<MasterBannerEdit> {
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

  Future updateBanner() async {
    if (imageFile == null ||
        _bannerNameController.text == '' ||
        _urlBannerController.text == '') {
      CustomSnackbar.showSnackbar(
          context, 'Pastikan semua input sudah diisi', SnackbarType.error);
    } else {
      BannerModel bannerModel = BannerModel(
          id: widget.bannerModel.id,
          name: _bannerNameController.text,
          urlAsset: _urlBannerController.text,
          isActive: isActive,
          imageFile: imageFile);
      bannerBloc.add(UpdateBanner(bannerModel));
    }
  }

  Future deleteBanner() async {
    BannerModel bannerModel = BannerModel(id: widget.bannerModel.id);
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
              bannerBloc.add(DeleteBanner(bannerModel));
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
    imageFile = file;

    setState(() {});
  }

  void initValue() {
    _bannerNameController.text = widget.bannerModel.name ?? '';
    _urlBannerController.text = widget.bannerModel.urlAsset ?? '';
    isActive = widget.bannerModel.isActive ?? false;
    if (widget.bannerModel.images != null) {
      urlToFile(widget.bannerModel.images!);
    }
    setState(() {});
  }

  @override
  void initState() {
    bannerBloc = BlocProvider.of<BannerBloc>(context);
    initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<BannerBloc, BannerState>(
      listener: (context, state) {
        if (state is UpdateBannerSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is UpdateBannerError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        } else if (state is DeleteBannerSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is DeleteBannerError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                widget.bannerModel.name ?? '',
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
                              onPressed: () => deleteBanner(),
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
                              onPressed: () => updateBanner(),
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
              BlocBuilder<BannerBloc, BannerState>(
                builder: (context, state) {
                  if (state is UpdateBannerLoading ||
                      state is DeleteBannerLoading) {
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
