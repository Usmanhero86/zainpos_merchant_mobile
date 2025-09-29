import 'package:flutter/material.dart';

class BuildTransactionCard extends StatelessWidget {
  final String status;
  final String reference;
  final String terminal;
  final String type;
  final String date;
  final String amount;
  final String balance;

  const BuildTransactionCard({
    super.key,
    required this.status,
    required this.reference,
    required this.terminal,
    required this.type,
    required this.date,
    required this.amount,
    this.balance = '',
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth * 0.04;
    double? parsed = double.tryParse(amount);
    final displayAmount =
    parsed == null ? '—' : (parsed / 100).toStringAsFixed(2);

    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(
        horizontal: scale * 0.5,
        vertical: scale * 0.3,
      ),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(scale * 0.8),
      ),
      child: Padding(
        padding: EdgeInsets.all(scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status + Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  status.toUpperCase() ,
                  style: TextStyle(
                    fontSize: scale * 0.7,
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Text(' - REF- $reference', style: TextStyle(
                    color: Colors.grey,
                    overflow: TextOverflow.ellipsis,
                  ),),
                ),
                Text(
                 '₦$displayAmount',
                  style: TextStyle(
                    fontSize: scale * 1.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
            SizedBox(height: scale * 0.4),

            // Terminal
            Text(
              terminal,
              style: TextStyle(
                fontSize: scale * 0.9,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: scale * 0.4),

            // Type + Date
            Row(
              children: [
                Flexible(
                  child: Text(
                    type.toUpperCase(),
                    style: TextStyle(
                      fontSize: scale * 0.8,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: scale * 0.5),
                Flexible(
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: scale * 0.8,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
