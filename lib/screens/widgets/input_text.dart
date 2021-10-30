import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool? obscureText, readOnly;
  final TextInputType? textInputType;

  const InputText(
      {this.hintText,
      this.controller,
      this.obscureText,
      this.textInputType,
      this.readOnly});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controller,
        readOnly: readOnly ?? false,
        obscureText: obscureText ?? false,
        keyboardType: textInputType ?? TextInputType.text,
        decoration: InputDecoration(
            hintText: hintText ?? '',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent.shade700),
            ),
            fillColor: Color(0xfff3f3f4),
            filled: true),
      ),
    );
  }
}
