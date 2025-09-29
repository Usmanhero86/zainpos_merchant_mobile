import 'package:flutter/material.dart';

class CompletionMessage extends StatelessWidget {
  final double width;
  final double height;
  final Map<String, dynamic> transferData;

  const CompletionMessage({
    super.key,
    required this.width,
    required this.height,
    required this.transferData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          children: [
            Icon(Icons.celebration, color: Colors.orange, size: width * 0.1),
            SizedBox(height: height * 0.01),
            Text(
              'Transfer Successful!',
              style: TextStyle(
                fontSize: width * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: height * 0.005),
            Text(
              '₦${transferData['amount']} was sent to ${transferData['accountName']}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width * 0.035,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
