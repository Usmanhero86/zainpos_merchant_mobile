import 'package:flutter/material.dart';

Widget networkOption({
  required Widget icon,
  required String title,
  required String description,
  required VoidCallback onTap,
}) {
  return Column(
    children: [
      GestureDetector(
        onTap: onTap,
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: Row(
            children: [
              icon,
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:  TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style:  TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}