import 'package:flutter/material.dart';
import '../../../services/models/response_model/dispute_list_response.dart';

class DisputeResolved extends StatelessWidget {
  const DisputeResolved({super.key, required this.dispute});
  final DisputeModel dispute;

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
          'Back to disputes',
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
                    _buildRow('Actual Amount', '₦${dispute.txnAmount.toStringAsFixed(2)}', labelStyle, valueStyle),
                    _buildRow('Settled Amount', '₦${dispute.txnAmount ?? "0.00"}', labelStyle, valueStyle),
                    _buildRow('Charged Amount', '₦${dispute.txnAmount.toStringAsFixed(2) ?? "0.00"}', labelStyle, valueStyle),
                    _buildRow('Terminal Name', dispute.terminalId, labelStyle, valueStyle),

                    const Divider(height: 32),

                    Text('PAYMENT INFORMATION',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildRow('Transaction Type', dispute.cardType, labelStyle, valueStyle),

                    Text('Status', style: labelStyle),
                    Text(
                      dispute.status.toUpperCase(),
                      style: valueStyle.copyWith(color: _getStatusColor(dispute.status)),
                    ),

                    const SizedBox(height: 12),
                    _buildRow('Transaction Reference', dispute.txnRrn, labelStyle, valueStyle),
                    _buildRow('Date and time', _formatDateTime(dispute.txnDate), labelStyle, valueStyle),
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

  String _formatDateTime(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} - T${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'RESOLVED':
        return Colors.green;
      case 'OPEN':
        return Colors.blue;
      case 'REFUNDED':
        return Colors.brown;
      case 'PENDING':
        return Colors.orange;
      case 'FAILED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}