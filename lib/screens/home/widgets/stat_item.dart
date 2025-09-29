import 'package:flutter/material.dart';

Widget statItem(String title, String value, double screenWidth) {
  return Column(
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: screenWidth * 0.035,
          color: Colors.grey[600],
        ),
      ),
      SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          fontSize: screenWidth * 0.045,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  );
}
