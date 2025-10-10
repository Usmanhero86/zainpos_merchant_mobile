import 'package:flutter/material.dart';
import '../../../app/models/transaction_model.dart';

class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({super.key, required this.transaction});
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    TextStyle labelStyle = TextStyle(
      color: Colors.grey[700],
      fontSize: screenWidth * 0.03,
    );
    TextStyle valueStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: screenWidth * 0.040,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Back to transactions',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transaction Details',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow('Amount', '₦${transaction.amount.toStringAsFixed(2)}', labelStyle, valueStyle),
                    _buildRow('Terminal', transaction.terminal, labelStyle, valueStyle),

                    const Divider(height: 32),

                    const Text(
                      'PAYMENT INFORMATION',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildRow('Transaction Type', 'Card', labelStyle, valueStyle),

                    Text('Status', style: labelStyle),
                    Text(
                      transaction.status.toUpperCase(),
                      style: valueStyle.copyWith(
                          color: transaction.status.toUpperCase() == 'SUCCESS' ? Colors.green : Colors.red
                      ),
                    ),

                    const SizedBox(height: 12),
                    _buildRow('Transaction Reference', transaction.reference, labelStyle, valueStyle),
                    _buildRow('Date', transaction.date, labelStyle, valueStyle),

                    const Divider(height: 32),

                    if (transaction.status.toUpperCase() == 'SUCCESS')
                      TextButton.icon(
                        onPressed: () {
                          // Handle receipt download
                        },
                        icon: Image.asset(
                          'assets/logos/download-03.png',
                          height: 16,
                          width: 16,
                        ),
                        label: const Text(
                          'Download Receipt',
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    else
                      TextButton.icon(
                        onPressed: () {
                          // Handle dispute logging for failed transactions
                        },
                        icon: Image.asset(
                          'assets/logos/coins-swap-01.png',
                          height: 13.33,
                          width: 13.33,
                        ),
                        label: const Text(
                          'Log Dispute',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, TextStyle labelStyle, TextStyle valueStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: labelStyle),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}