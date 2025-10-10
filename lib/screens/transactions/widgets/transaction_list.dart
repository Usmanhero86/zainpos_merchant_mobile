import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/models/response_model/bank_deposit_history_response.dart';

class TransactionsList extends StatelessWidget {
  final List<BankDepositItem> data;
  const TransactionsList({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final tx = data[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tx.txnRef,
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '₦${_formatAmount(tx.amountAfterCharges)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  tx.terminalName,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'From: ${tx.senderAccountName} - ${tx.senderBankName}',
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'To: ${tx.beneficiaryAccountName} - ${tx.beneficiaryBankName}',
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('yyyy-MM-dd hh:mm a').format(tx.txnDate),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatAmount(dynamic raw) {
    // Accepts int, double, or String
    double value;

    if (raw is int) {
      value = raw / 100;
    } else if (raw is double) {
      value = raw / 100;
    } else if (raw is String) {
      // Remove commas or symbols if present, then parse
      final cleaned = raw.replaceAll(RegExp(r'[^\d.]'), '');
      value = double.tryParse(cleaned) != null
          ? (double.parse(cleaned) / 100)
          : 0.0;
    } else {
      value = 0.0;
    }

    // Show two decimal places
    return value.toStringAsFixed(2);
  }

}