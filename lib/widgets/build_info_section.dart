import 'package:flutter/material.dart';

class BuildInfoSection extends StatelessWidget {
  final String title;
  final String content;
  final double? titleFontSize;
  final double? contentFontSize;
  final Color? titleColor;
  final Color? contentColor;

  const BuildInfoSection({
    super.key,
    required this.title,
    required this.content,
    this.titleFontSize,
    this.contentFontSize,
    this.titleColor,
    this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final defaultTitleSize = size.width * 0.04;   // ~16 at 400px width
    final defaultContentSize = size.width * 0.045; // ~18 at 400px width

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: titleFontSize ?? defaultTitleSize,
            color: titleColor ?? Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: TextStyle(
            fontSize: contentFontSize ?? defaultContentSize,
            fontWeight: FontWeight.w500,
            color: contentColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
