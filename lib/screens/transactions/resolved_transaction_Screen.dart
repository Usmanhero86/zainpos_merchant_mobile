import 'package:flutter/material.dart';

class ResolvedTransactionScreen extends StatelessWidget {
  const ResolvedTransactionScreen({super.key});

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
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Back to transactions',
          style: TextStyle(fontSize: 16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transactions Details', style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16)),
            Card(
              color: Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow('Actual Amount', '₦22,500.00', labelStyle, valueStyle),
                    _buildRow('Settled Amount', '₦22,400.00', labelStyle, valueStyle),
                    _buildRow('Charged Amount', '₦100.00', labelStyle, valueStyle),
                    _buildRow('Terminal Name', 'Nassarawa Terminal', labelStyle, valueStyle),

                    const Divider(height: 32),

                    Text('PAYMENT INFORMATION',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildRow('Transaction Type', 'Card', labelStyle, valueStyle),

                    Text('Status', style: labelStyle),
                    Text('RESOLVED', style: valueStyle.copyWith(color: Colors.green)),

                    const SizedBox(height: 12),
                    _buildRow('Transaction Reference', 'REF-269528555', labelStyle, valueStyle),
                    _buildRow('Date and time', '2024-02-16 - T15:02:47.26', labelStyle, valueStyle,),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, TextStyle labelStyle, TextStyle valueStyle,) {
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
