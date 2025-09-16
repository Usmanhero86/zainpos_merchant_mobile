import 'package:flutter/material.dart';

class BackspaceButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;

  const BackspaceButton({
    super.key,
    required this.onPressed,
    this.size = 70,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          Icons.backspace,
          size: size * 0.35,
        ),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          foregroundColor: Colors.grey,
          elevation: 2,
          shadowColor: Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }
}
