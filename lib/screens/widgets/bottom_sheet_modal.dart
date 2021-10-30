import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomSheetModal {
  static show(BuildContext context,
      {double? height,
      Color? color,
      List<Widget>? children,
      MainAxisAlignment? mainAxisAlignment,
      MainAxisSize? mainAxisSize}) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: height ?? 100,
          color: color ?? Colors.white,
          child: Center(
            child: Column(
                mainAxisAlignment:
                    mainAxisAlignment ?? MainAxisAlignment.center,
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
          ),
        );
      },
    );
  }
}
