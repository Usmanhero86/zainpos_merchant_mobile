import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  final String number;
  final Function(String) onPressed;
  final double size;

  const NumberButton({
    super.key,
    required this.number,
    required this.onPressed,
    this.size = 70,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TextButton(
        onPressed: () => onPressed(number),
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          foregroundColor: Colors.black,
          textStyle: TextStyle(
            fontSize: size * 0.34,
            fontWeight: FontWeight.w500,
          ),
          elevation: 2,
          shadowColor: Colors.grey.withOpacity(0.5),
        ),
        child: Text(number),
      ),
    );
  }
}
