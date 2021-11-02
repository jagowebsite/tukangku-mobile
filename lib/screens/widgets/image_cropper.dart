import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tukangku/blocs/profile_bloc/profile_bloc.dart';

class ImageCropper extends StatefulWidget {
  const ImageCropper({Key? key}) : super(key: key);

  @override
  _ImageCropperState createState() => _ImageCropperState();
}

class _ImageCropperState extends State<ImageCropper> {
  late ProfileBloc _profileBloc;
  final cropKey = GlobalKey<CropState>();
  File? _file;
  File? _sample;
  File? _lastCropped;

  // Apakah sedang proses cropping
  bool isCrop = false;

  @override
  void dispose() {
    super.dispose();
    if (_file != null) {
      _file!.delete();
    }
    if (_sample != null) {
      _sample!.delete();
    }
    if (_lastCropped != null) {
      _lastCropped!.delete();
    }
  }

  @override
  void initState() {
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is UpdatePhotoSuccess) {
          Navigator.pop(context);
        } else if (state is UpdatePhotoError) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.white,
              child: isCrop ? _buildCroppingImage() : _buildOpenImage(),
            ),
            Positioned(
                child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.chevron_left,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ),
            )),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is UpdatePhotoLoading) {
                  return Container(
                      width: size.width,
                      height: size.height,
                      color: Colors.white.withOpacity(0.5),
                      child: Center(
                        child: Container(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: Colors.red.shade700,
                              strokeWidth: 2,
                            )),
                      ));
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCroppingImage() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Crop.file(
            _sample!,
            key: cropKey,
            aspectRatio: 1,
            alwaysShowGrid: true,
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.grey.shade600,
                  child: TextButton(
                    child: Text(
                      'Open Image',
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: Colors.white),
                    ),
                    onPressed: () async {
                      await _openImage();
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.grey.shade700,
                  child: TextButton(
                    child: Text(
                      'Crop Image',
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: Colors.white),
                    ),
                    onPressed: () => _cropImage(),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOpenImage() {
    return Center(
        child: _lastCropped != null
            ? Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.black,
                      child: Image.file(_lastCropped!),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.grey.shade700,
                          child: TextButton(
                            child: Text(
                              'Change Image',
                              style: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(color: Colors.white),
                            ),
                            onPressed: () async {
                              await _openImage();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.green.shade700,
                          child: TextButton(
                            child: Text(
                              'Update Photo',
                              style: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(color: Colors.white),
                            ),
                            onPressed: () {
                              _profileBloc.add(UpdatePhoto(_lastCropped!));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : GestureDetector(
                onTap: () async {
                  await _openImage();
                },
                child: Icon(
                  Icons.add_a_photo_outlined,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
              ));
  }

  Future<void> _openImage() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 1280);
    final file = File(pickedFile!.path);
    final sample = await ImageCrop.sampleImage(
      file: file,
      preferredSize: context.size!.longestSide.ceil(),
    );

    if (_sample != null) {
      _sample!.delete();
    }
    if (_file != null) {
      _file!.delete();
    }

    setState(() {
      isCrop = true;
      _sample = sample;
      _file = file;
    });
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: _file!,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    sample.delete();

    if (_lastCropped != null) {
      _lastCropped!.delete();
    }

    setState(() {
      isCrop = false;
      _lastCropped = file;
    });
  }
}
