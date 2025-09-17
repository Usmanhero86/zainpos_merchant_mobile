import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback onTap;
  final bool isLogout;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;
  final bool showTrailingIcon;
  final double? textSize;

  const ActionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.isLogout = false,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
    this.showTrailingIcon = true,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double paddingScale = size.width * 0.04; // dynamic padding
    final double fontScale = size.width * 0.045;   // dynamic font size

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(paddingScale),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            icon,
            SizedBox(width: paddingScale),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontScale,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ),
            if (showTrailingIcon)
              Icon(
                Icons.arrow_forward_ios,
                size: fontScale * 0.9,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }
}
