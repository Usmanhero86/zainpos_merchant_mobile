import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/models/response_model/bank_deposit_history_response.dart';

class TransactionsList extends StatelessWidget {
  final List<BankDepositItem> data;
 const TransactionsList({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final tx = data[index];
        return Card(
          color: Colors.white,
          margin: EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tx.txnRef,
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                    Text(
                      '₦${formatAmount(tx.amountAfterCharges)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 2),
                Text(
                  tx.terminalName,
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold
                  ),
                ),
                if (tx.txnRef != null && tx.txnRef.isNotEmpty) ...[
                  SizedBox(height: 2),
                  Text(
                    tx.txnRef,
                    style: TextStyle(fontSize: 13, color: Colors.grey
                    ),
                  ),
                ],
                SizedBox(height: 4),
                Text(
                  DateFormat('yyyy-MM-dd hh:mm a').format(tx.txnDate),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
String formatAmount(dynamic raw) {
  double value;

  if (raw is int) {
    value = raw / 100;
  } else if (raw is double) {
    value = raw / 100;
  } else if (raw is String) {
    final cleaned = raw.replaceAll(RegExp(r'[^\d.]'), '');
    value = double.tryParse(cleaned) != null
        ? (double.parse(cleaned) / 100)
        : 0.0;
  } else {
    value = 0.0;
  }
  return value.toStringAsFixed(2);
}
