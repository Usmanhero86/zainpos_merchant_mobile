import 'package:flutter/material.dart';

Widget buildRow(String label, String value, TextStyle labelStyle, TextStyle valueStyle,) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    ),
  );
}
