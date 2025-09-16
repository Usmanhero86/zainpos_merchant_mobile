import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = List.generate(4, (index) => '₦22,500.00');
    return ListView.separated(
      itemCount: transactions.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            transactions[index],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('TRN-REF 269528555  •  2024-02-16'),
          trailing:  IconButton(
            onPressed: () { },
            icon: Icon(Icons.more_vert,),),
        );
      },
    );
  }
}
