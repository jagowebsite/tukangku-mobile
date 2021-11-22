import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomSheetModal {
  static show(BuildContext context,
      {double? height,
      Color? color,
      List<Widget>? children,
      MainAxisAlignment? mainAxisAlignment,
      CrossAxisAlignment? crossAxisAlignment,
      EdgeInsetsGeometry? padding,
      MainAxisSize? mainAxisSize}) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: height ?? 100,
          color: color ?? Colors.white,
          padding: padding ?? EdgeInsets.all(10),
          child: Column(
              crossAxisAlignment:
                  crossAxisAlignment ?? CrossAxisAlignment.center,
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
              mainAxisSize: mainAxisSize ?? MainAxisSize.min,
              children: children ?? []
              // children: <Widget>[
              //   const Text('Modal BottomSheet'),
              //   ElevatedButton(
              //     child: const Text('Close BottomSheet'),
              //     onPressed: () => Navigator.pop(context),
              //   )
              // ],
              ),
        );
      },
    );
  }
}
