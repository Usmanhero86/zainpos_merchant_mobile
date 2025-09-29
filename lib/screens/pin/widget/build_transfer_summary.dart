import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/pin/widget/summary_row.dart';

class TransferSummary extends StatelessWidget {
  final double width;
  final double height;
  final Map<String, dynamic> transferData;

  const TransferSummary({
    super.key,
    required this.width,
    required this.height,
    required this.transferData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transfer Summary',
              style: TextStyle(
                fontSize: width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: height * 0.015),

            // Amount
            SummaryRow(
              label: 'Amount',
              value: '₦${transferData['amount'] ?? '0'}',
              width: width,
            ),

            // To
            SummaryRow(
              label: 'To',
              value: transferData['accountName'] ?? 'N/A',
              width: width,
            ),

            // Bank
            SummaryRow(
              label: 'Bank',
              value: transferData['bank']?.name ?? 'N/A',
              width: width,
            ),

            // Account
            SummaryRow(
              label: 'Account',
              value: transferData['accountNumber'] ?? 'N/A',
              width: width,
            ),

            // Narration (optional)
            if (transferData['narration'] != null &&
                transferData['narration'].toString().isNotEmpty)
              SummaryRow(
                label: 'Narration',
                value: transferData['narration'],
                width: width,
              ),
          ],
        ),
      ),
    );
  }
}
