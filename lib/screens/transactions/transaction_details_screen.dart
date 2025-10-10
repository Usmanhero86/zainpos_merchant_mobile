import 'package:flutter/material.dart';

class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({
    super.key,
    required this.transactionType,
    required this.amount,
    required this.terminalName,
    required this.transactionReference,
    required this.date,
    required this.status,
    this.settledAmount,
    this.chargedAmount,
    this.cardType,
  });

  final String transactionType;
  final double amount;
  final String terminalName;
  final String transactionReference;
  final String date;
  final String status;
  final double? settledAmount;
  final double? chargedAmount;
  final String? cardType;

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = TextStyle(
      color: Colors.grey[400],
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );
    TextStyle valueStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );

    Color getStatusColor(String status) {
      switch (status.toUpperCase()) {
        case 'SUCCESS':
        case 'SUCCESSFUL':
        case 'COMPLETED':
          return Colors.green;
        case 'FAILED':
        case 'DECLINED':
          return Colors.red;
        case 'PENDING':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,size: 24,),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Back to transactions',
          style: TextStyle(fontSize: 14,
              fontWeight:FontWeight.w400, color: Colors.grey),
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
                  fontWeight: FontWeight.w600,
                  fontSize: 18
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
                    _buildRow('Amount', '₦${amount.toStringAsFixed(2)}', labelStyle, valueStyle),

                    if (settledAmount != null)
                      _buildRow('Settled Amount', '₦${settledAmount!.toStringAsFixed(2)}', labelStyle, valueStyle),

                    if (chargedAmount != null)
                      _buildRow('Charged Amount', '₦${chargedAmount!.toStringAsFixed(2)}', labelStyle, valueStyle),

                    _buildRow('Terminal Name', terminalName, labelStyle, valueStyle),

                    const Divider(height: 32),

                    Text(
                      'PAYMENT INFORMATION',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildRow('Transaction Type', transactionType, labelStyle, valueStyle),

                    if (cardType != null)
                      _buildRow('Card Type', cardType!, labelStyle, valueStyle),

                    Text('Status', style: labelStyle),
                    Text(
                      status.toUpperCase(),
                      style: valueStyle.copyWith(color: getStatusColor(status)),
                    ),

                    const SizedBox(height: 12),
                    _buildRow('Transaction Reference', transactionReference, labelStyle, valueStyle),
                    _buildRow('Date', date, labelStyle, valueStyle),

                    const Divider(height: 32),

                    if (status.toUpperCase() == 'SUCCESS' || status.toUpperCase() == 'SUCCESSFUL')
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
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.blue),
                        ),
                      )
                    else
                      TextButton.icon(
                        onPressed: () {
                          // Handle dispute logging
                        },
                        icon: Image.asset(
                          'assets/logos/coins-swap-01.png',
                          height: 16,
                          width: 16,
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