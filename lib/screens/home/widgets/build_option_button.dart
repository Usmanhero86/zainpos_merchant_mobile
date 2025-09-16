import 'package:flutter/material.dart';

Widget buildOptionButton({
  required Widget icon,
  required String title,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        alignment: AlignmentDirectional.centerStart,
        backgroundColor: Colors.white,
        padding:  EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          icon,
          SizedBox(width: 12),
          Text(
            title,
            style:  TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}