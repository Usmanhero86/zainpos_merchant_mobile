import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../bank_transfer.dart';

class BankListItem extends StatelessWidget {
  final Bank bank;
  final double ringSize;
  final double fontSize;
  final double spacing;

  const BankListItem({
    super.key,
    required this.bank,
    required this.ringSize,
    required this.fontSize,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: spacing),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing),
        child: Row(
          children: [
            _PartialRingIndicator(
              percentage: bank.successRate,
              size: ringSize,
            ),
            SizedBox(width: spacing),
            Flexible(
              child: Text(
                bank.name,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PartialRingIndicator extends StatelessWidget {
  final int percentage;
  final double size;

  const _PartialRingIndicator({
    required this.percentage,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.8,
            height: size * 0.8,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
            ),
          ),
          CustomPaint(
            size: Size(size, size),
            painter: _PartialRingPainter(percentage),
          ),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: size * 0.25,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PartialRingPainter extends CustomPainter {
  final int percentage;
  const _PartialRingPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;
    const strokeWidth = 3.0;

    final backgroundPaint = Paint()
      ..color = Colors.green.shade100
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, backgroundPaint);

    final filledPaint = Paint()
      ..color = Colors.green.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final filledAngle = 2 * math.pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      filledAngle,
      false,
      filledPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
