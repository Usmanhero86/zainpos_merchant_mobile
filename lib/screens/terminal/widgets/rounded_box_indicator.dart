import 'package:flutter/material.dart';

class RoundedBoxIndicator extends Decoration {
  final Color color;
  final BorderRadius radius;
  final EdgeInsets insets;

  const RoundedBoxIndicator({
    required this.color,
    this.radius = const BorderRadius.all(Radius.circular(8)),
    this.insets = const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _RoundedBoxPainter(color, radius, insets);
  }
}

class _RoundedBoxPainter extends BoxPainter {
  final Color color;
  final BorderRadius radius;
  final EdgeInsets insets;

  _RoundedBoxPainter(this.color, this.radius, this.insets);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final rect = offset & cfg.size!;
    final paintRect = insets.deflateRect(rect);
    final paint = Paint()..color = color;
    final rrect = radius.toRRect(paintRect);
    canvas.drawRRect(rrect, paint);
  }
}
