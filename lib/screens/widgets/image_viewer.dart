import 'package:flutter/material.dart';
import 'package:tukangku/screens/widgets/custom_cached_image.dart';

class ImageViewer extends StatefulWidget {
  final String imageURL;
  const ImageViewer({Key? key, required this.imageURL}) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: size.width,
          height: size.height,
          child: ClipRRect(
              child: CustomCachedImage.build(
            context,
            imgUrl: widget.imageURL != ''
                ? widget.imageURL
                : 'https://picsum.photos/64',
          )),
        ),
        Positioned(
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: Colors.white)),
            ),
          ),
        )
      ],
    ));
  }
}
