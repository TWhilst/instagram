import 'package:flutter/material.dart';

//this CTextField (Categorised text field) was made so as to give the text field its details and to make the login page more simple and precise
class CTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPassword;
  final String hintText;
  final TextInputType textInputType;

  const CTextField({Key? key,
    required this.textEditingController,
    this.isPassword = false,
    required this.hintText,
    required this.textInputType
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imputborder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: imputborder,
        focusedBorder: imputborder,
        enabledBorder: imputborder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      // this is the dot view that shows when imputing password
      obscureText: isPassword,
    );
  }
}
