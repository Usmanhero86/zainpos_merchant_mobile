import 'package:flutter/material.dart';

class BuildTransactionSummary extends StatelessWidget {
  const BuildTransactionSummary({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.label,
    required this.value,
    required this.color
  });

  final double screenWidth;
  final double screenHeight;
    final String label;
  final String value;
     final Color color;
  @override
  Widget build(BuildContext context) {
    return   Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: screenWidth * 0.04, color: const Color(0xFF555555))),
          Text(value, style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold, color: color)),
        ],
      );
    }

  }

