import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final double fontSize;
  final Widget? prefix;
  final int maxLines;

  const InputField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    required this.fontSize,
    this.prefix,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: fontSize * 0.9,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        prefix: prefix,
        contentPadding: EdgeInsets.symmetric(
          horizontal: fontSize,
          vertical: fontSize * 0.8,
        ),
      ),
    );
  }
}
