import 'package:flutter/material.dart';

class PercentageColor extends StatelessWidget {
  final int percentage;
  final Widget child;
  final Color? highColor;
  final Color? mediumColor;
  final Color? lowColor;

  const PercentageColor({
    super.key,
    required this.percentage,
    required this.child,
    this.highColor,
    this.mediumColor,
    this.lowColor,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: TextStyle(color: _getColor()),
      child: child,
    );
  }

  Color _getColor() {
    if (percentage >= 90) return highColor ?? Colors.green;
    if (percentage >= 80) return mediumColor ?? Colors.orange;
    return lowColor ?? Colors.red;
  }
}