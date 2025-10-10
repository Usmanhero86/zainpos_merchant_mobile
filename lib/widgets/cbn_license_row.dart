import 'package:flutter/material.dart';

class CbnLicenseRow extends StatelessWidget {
  final String text;
  final String imagePath;
  final double fontSize;
  final double imageHeight;
  final double imageWidth;
  final Color textColor;

  const CbnLicenseRow({
    super.key,
    this.text = 'Licensed by Central Bank of Nigeria (CBN)',
    this.imagePath = 'assets/logos/cbn2.png',
    this.fontSize = 12,
    this.imageHeight = 24,
    this.imageWidth = 24,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w400
          ),
        ),
        Image.asset(
          imagePath,
          height: imageHeight,
          width: imageWidth,
        ),
      ],
    );
  }
}
