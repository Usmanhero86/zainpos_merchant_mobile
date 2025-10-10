import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  final String number;
  final Function(String) onPressed;
  final double size;
  final Color? color;

  const NumberButton({
    super.key,
    required this.number,
    required this.onPressed,
    this.size = 70,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TextButton(
        onPressed: () => onPressed(number),
        style: TextButton.styleFrom(
          backgroundColor: Colors.blue[100],
          shape: const CircleBorder(),
          foregroundColor: Colors.blue, // This makes the text blue
          elevation: 2,
        ),
        child: Text(
          number,
          style: TextStyle(
            fontSize: 34.18,
            fontWeight: FontWeight.w700,
            color: Colors.blue, // Explicitly set text color to blue
          ),
        ),
      ),
    );
  }
}