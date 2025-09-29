import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  final Color? titleColor;
  final Color? descriptionColor;
  final Color? backgroundColor;

  const SettingItem({
    super.key,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.titleColor,
    this.descriptionColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Container(
      height: h * 0.13,
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(w * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: w * 0.02,
            offset: Offset(0, h * 0.002),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: w * 0.050,
                    fontWeight: FontWeight.bold,
                    color: titleColor ?? Colors.black,
                  ),
                ),
                SizedBox(height: h * 0.005),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: w * 0.050,
                    color: descriptionColor ?? Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: w * 0.04),
          Transform.scale(
            scale: w * 0.003 + 0.04,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: activeColor ?? Colors.blue.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
