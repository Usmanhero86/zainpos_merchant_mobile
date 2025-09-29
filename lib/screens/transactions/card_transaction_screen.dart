import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/provider/card_purchase_provider.dart';

class CardTransactionsScreen extends StatefulWidget {
  const CardTransactionsScreen({super.key});

  @override
  State<CardTransactionsScreen> createState() => _CardTransactionsScreenState();
}

class _CardTransactionsScreenState extends State<CardTransactionsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => context.read<CardPurchaseProvider>().loadCardPurchases(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CardPurchaseProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth * 0.04; // base scale for padding & fonts

    if (provider.isLoading && provider.purchases.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.purchases.isEmpty) {
      return Center(
        child: Text(
          provider.errorMessage!,
          style: TextStyle(fontSize: scale),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (provider.purchases.isEmpty) {
      return Center(
        child: Text(
          'No card transactions',
          style: TextStyle(fontSize: scale),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: EdgeInsets.all(scale * 0.8),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: provider.purchases.length,
        itemBuilder: (_, index) {
          final item = provider.purchases[index];
          final amount = double.tryParse(item.amount.toString())?? 0;
          final formattedDate =
              '${item.txnDate.year}-${item.txnDate.month.toString().padLeft(2, '0')}-${item.txnDate.day.toString().padLeft(2, '0')} '
              '${TimeOfDay.fromDateTime(item.txnDate).format(context)}';

          return Card(
            margin: EdgeInsets.symmetric(vertical: scale * 0.5),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(scale * 0.7),
            ),
            elevation: 1,
            child: Padding(
              padding: EdgeInsets.all(scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // reference and amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.txnRef,
                          style: TextStyle(
                            fontSize: scale * 0.8,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '₦${_formatAmount(amount.toStringAsFixed(2))}',
                        style: TextStyle(
                          fontSize: scale * 1.1,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: scale * 0.07),

                  /// Terminal name
                  Text(
                    item.terminalName,
                    style: TextStyle(
                      fontSize: scale,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: scale * 0.1),

                  /// Reference (again) and date/time
                  Text(
                    '${item.txnRef}\n$formattedDate',
                    style: TextStyle(
                      fontSize: scale * 0.8,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
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
