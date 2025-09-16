import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/dispute/dispute_resolved.dart';
import 'package:zainpos_merchant_mobile/screens/dispute/model/dispute_model.dart';
import 'package:zainpos_merchant_mobile/screens/transactions/failed_transaction_screen.dart';
import '../../transactions/resolved_transaction_Screen.dart';

class DisputeItem extends StatelessWidget {
  const DisputeItem({super.key, required this.transaction});
  final DisputeModel transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                transaction.status,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  ' - REF: ${transaction.reference}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              Text(
                '₦${transaction.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) {
                      if(transaction.resolved == 'RESOLVED') {
                        return DisputeResolved();
                      } else {
                        return FailedTransactionScreen();
                      }

                    }  ),
                  );

                },
                icon: const Icon(Icons.arrow_forward_ios, size: 12),
              ),
            ],
          ),
          Text(transaction.terminal,
              style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text('${transaction.resolved} ',
                  style: TextStyle(color: transaction.resolved == 'RESOLVED' ? Colors.green : Colors.grey,)),
              Text(' ${transaction.date}', style: TextStyle(color: Colors.grey),)
            ],
          ),
        ],
      ),
    );
  }

}

