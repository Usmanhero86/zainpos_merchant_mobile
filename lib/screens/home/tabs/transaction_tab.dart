import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/home/tabs/terminal_tab.dart';
import 'package:zainpos_merchant_mobile/screens/terminal/nassarawa_terminal.dart';
import '../../../app/models/transaction_model.dart';
import '../../../widgets/build_transaction_item.dart';

class TransactionsTab extends StatelessWidget {
  TransactionsTab({super.key});

  final List<Transaction> transactions = [
    Transaction(
      status: 'SUCCESS',
      terminal: 'Nassarawa Terminal',
      amount: 22500.00,
      date: '2024-02-18',
      reference: '286/286586',
    ),
    Transaction(
      status: 'FAILED',
      terminal: 'Sharada Terminal-1',
      amount: 22500.00,
      date: '2024-02-18',
      reference: '286/286586',
    ),
    Transaction(
      status: 'SUCCESS',
      terminal: 'Nassarawa Terminal',
      amount: 22500.00,
      date: '2024-02-18',
      reference: '286/286586',
    ),
    Transaction(
      status: 'SUCCESS',
      terminal: 'Sharada Terminal-2',
      amount: 22500.00,
      date: '2024-02-18',
      reference: '286/286586',
    ),
    Transaction(
      status: 'FAILED',
      terminal: 'Sharada Terminal-1',
      amount: 22500.00,
      date: '2024-02-18',
      reference: '286/286586',
    ),
    Transaction(
      status: 'SUCCESS',
      terminal: 'Sharada Terminal-2',
      amount: 22500.00,
      date: '2024-02-18',
      reference: '286/286586',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Transactions'),
        actions: [
          IconButton(
            icon:   Image(
              height: 24,  width: 24,
              image: AssetImage('assets/logos/searchIcon.png'),
            ),
            onPressed: () {
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return BuildTransactionItem(transaction: transactions[index]);
        },
        separatorBuilder: (context, index) =>  Divider(
          color: Colors.grey[200],
          thickness: 1,
          height: 0.5,
        ),
      ),
    );
  }

}
