// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// class CameraScreen extends StatefulWidget {
//   final List<CameraDescription> cameras;
//   const CameraScreen({Key? key, required this.cameras}) : super(key: key);

//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   late CameraController cameraController;

//   Future<void> initializeCamera() async {
//     // List<CameraDescription> cameras = await availableCameras();
//     // cameraController = CameraController(cameras[1], ResolutionPreset.medium);
//     await cameraController.initialize();
//   }

//   Future<File?> takePicture() async {
//     // Directory root = await getTemporaryDirectory();
//     // String directoryPath = '${root.path}/guided_camera';
//     // await Directory(directoryPath).create(recursive: true);
//     // String filePath = '$directoryPath/${DateTime.now()}.jpg';
//     File? imageFile;

//     try {
//       XFile? result = await cameraController.takePicture();
//       imageFile = File(result.path);
//     } catch (e) {
//       return null;
//     }
//     return imageFile;
//   }

//   @override
//   void initState() {
//     cameraController =
//         CameraController(widget.cameras[0], ResolutionPreset.medium);
//     initializeCamera();
//     super.initState();
//   }

//   // @override
//   // void dispose() {
//   //   cameraController.dispose();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     // return Scaffold();
//     if (!cameraController.value.isInitialized) {
//       return Center(
//         child: Container(
//             width: 25,
//             height: 25,
//             child: CircularProgressIndicator(
//               color: Colors.orangeAccent.shade700,
//               strokeWidth: 3,
//             )),
//       );
//     } else {
//       return Scaffold(
//         body: Stack(
//           children: [
//             // SizedBox(
//             //   width: size.width,
//             //   height: size.height,
//             //   child: CameraPreview(cameraController),
//             // ),
//             CameraPreview(cameraController),
//             Positioned(
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       shape: CircleBorder(), primary: Colors.red),
//                   child: Container(
//                     width: 70,
//                     height: 70,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(shape: BoxShape.circle),
//                     child: Text(
//                       'I',
//                       style: TextStyle(fontSize: 24),
//                     ),
//                   ),
//                   onPressed: () async {
//                     if (!cameraController.value.isTakingPicture) {
//                       File? result = await takePicture();
//                       if (result != null) {
//                         Navigator.pop(context, result);
//                       }
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     // return FutureBuilder(
//     //     future: initializeCamera(),
//     //     builder: (_, snapshot) =>
//     //         (snapshot.connectionState == ConnectionState.done)
//     //             ? Stack(
//     //                 children: [
//     //                   SizedBox(
//     //                     width: size.width,
//     //                     height: size.height,
//     //                     child: CameraPreview(cameraController),
//     //                   ),
//     //                   Positioned(
//     //                     child: Align(
//     //                       alignment: Alignment.bottomCenter,
//     //                       child: ElevatedButton(
//     //                         style: ElevatedButton.styleFrom(
//     //                             shape: CircleBorder(), primary: Colors.red),
//     //                         child: Container(
//     //                           width: 70,
//     //                           height: 70,
//     //                           alignment: Alignment.center,
//     //                           decoration: BoxDecoration(shape: BoxShape.circle),
//     //                           child: Text(
//     //                             'I',
//     //                             style: TextStyle(fontSize: 24),
//     //                           ),
//     //                         ),
//     //                         onPressed: () async {
//     //                           if (!cameraController.value.isTakingPicture) {
//     //                             File? result = await takePicture();
//     //                             if (result != null) {
//     //                               Navigator.pop(context, result);
//     //                             }
//     //                           }
//     //                         },
//     //                       ),
//     //                     ),
//     //                   ),
//     //                 ],
//     //               )
//     //             : Center(
//     //                 child: Container(
//     //                     width: 25,
//     //                     height: 25,
//     //                     child: CircularProgressIndicator(
//     //                       color: Colors.orangeAccent.shade700,
//     //                       strokeWidth: 3,
//     //                     )),
//     //               ));
//   }
// }
