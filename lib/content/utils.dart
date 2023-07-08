import 'package:flutter/material.dart';

class UtilComponents {
  static String getAssetPath(String path) {
    return 'assets/$path';
  }

  static Container field(String text, bool obscure, TextEditingController ctrl,
      IconData? icon) =>
      Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: TextField(
          controller: ctrl,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: text,
            prefixIcon: icon != null ? Icon(icon) : null,
          ),
        ),
      );

  Container button(String text, function) => Container(
    height: 50,
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
    child: ElevatedButton(
      onPressed: function,
      child: Text(text),
    ),
  );

  SizedBox space(double height, double width) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
