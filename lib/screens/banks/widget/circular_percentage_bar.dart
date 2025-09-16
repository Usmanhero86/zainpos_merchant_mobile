import 'package:flutter/material.dart';

class CircularPercentageBar extends StatelessWidget {
  final int percentage;
  final Color? color;
  final double size;
  final double borderWidth;
  final double backgroundOpacity;
  final TextStyle? textStyle;

  const CircularPercentageBar({
    super.key,
    required this.percentage,
    this.color,
    this.size = 40,
    this.borderWidth = 2,
    this.backgroundOpacity = 0.2,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = color ?? _getPercentageColor(percentage);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              color: effectiveColor.withOpacity(backgroundOpacity),
              shape: BoxShape.circle,
              // border: Border.all(
              //   color: effectiveColor,
              //   width: borderWidth,
              // ),
            ),
            child: Center(
              child: Text(
                '$percentage%',
                style: textStyle ?? TextStyle(
                  fontSize: size * 0.25,
                  fontWeight: FontWeight.bold,
                  color: effectiveColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPercentageColor(int percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 80) return Colors.orange;
    return Colors.red;
  }
}