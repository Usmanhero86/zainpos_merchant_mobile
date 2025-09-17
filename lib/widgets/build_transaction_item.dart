import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/app/models/transaction_model.dart';
import 'package:zainpos_merchant_mobile/screens/transactions/failed_transaction_screen.dart';
import '../screens/transactions/success_transactions_screen.dart';

class BuildTransactionItem extends StatelessWidget {
  const BuildTransactionItem({super.key, required this.transaction});
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) {
                if(transaction.status == 'SUCCESS') {
                  return SuccessTransactionScreen();
                } else {
                  return FailedTransactionScreen();
                }

              }
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    transaction.status,
                    style: TextStyle(
                      color: transaction.status == 'SUCCESS' ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ' - REF: ${transaction.reference}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Text(
                    '₦${transaction.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) {
                          if(transaction.status == 'SUCCESS') {
                            return SuccessTransactionScreen();
                          } else {
                            return FailedTransactionScreen();
                          }

                        }
                        ),
                      );

                    },
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
              Text(transaction.terminal,
                style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('CARD - ${transaction.date}', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

  }

