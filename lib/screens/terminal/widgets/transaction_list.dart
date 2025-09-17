import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;
    final titleSize = isTablet ? 18.0 : 16.0;
    final subSize = isTablet ? 14.0 : 12.0;

    final transactions = List.generate(4, (index) => '₦22,500.00');

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            transactions[index],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: titleSize),
          ),
          subtitle: Text(
            'TRN-REF 269528555  •  2024-02-16',
            style: TextStyle(fontSize: subSize),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        );
      },
    );
  }
}
