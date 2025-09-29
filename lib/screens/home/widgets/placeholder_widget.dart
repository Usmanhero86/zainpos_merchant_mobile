import 'package:flutter/material.dart';

Widget noTransactionsPlaceholder(double screenWidth) {
  return Container(
    padding: EdgeInsets.all(40),
    child: Column(
      children: [
        Icon(Icons.receipt_long, size: 64, color: Colors.grey[300]),
        SizedBox(height: 16),
        Text(
          'No transactions yet',
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Your transactions will appear here once you start processing payments',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            color: Colors.grey[500],
          ),
        ),
      ],
    ),
  );
}
