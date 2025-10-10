import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/provider/card_purchase_provider.dart';
import 'package:zainpos_merchant_mobile/screens/transactions/transaction_details_screen.dart';

class CardTransactionsScreen extends StatefulWidget {
  const CardTransactionsScreen({super.key});

  @override
  State<CardTransactionsScreen> createState() => _CardTransactionsScreenState();
}

class _CardTransactionsScreenState extends State<CardTransactionsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      debugPrint("CardTransactionsScreen: Initializing and loading card purchases");
      context.read<CardPurchaseProvider>().loadCardPurchases();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CardPurchaseProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth * 0.04;

    // Enhanced debug information
    debugPrint('CardTransactionsScreen Build - Loading: ${provider.isLoading}, Error: ${provider.errorMessage}, Count: ${provider.purchases.length}');

    // Show loading only if we have no data and are loading
    if (provider.isLoading && provider.purchases.isEmpty) {
      debugPrint("Showing loading indicator");
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading card transactions...'),
          ],
        ),
      );
    }

    // Show error if we have an error and no data
    if (provider.errorMessage != null && provider.purchases.isEmpty) {
      debugPrint("Showing error: ${provider.errorMessage}");
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Failed to load card transactions',
              style: TextStyle(fontSize: scale * 1.2, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: scale * 2),
              child: Text(
                provider.errorMessage!,
                style: TextStyle(fontSize: scale),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                provider.loadCardPurchases();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Show empty state if we have no data and no error
    if (provider.purchases.isEmpty) {
      debugPrint("Showing empty state");
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.credit_card, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No card transactions',
              style: TextStyle(fontSize: scale * 1.2, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Card transactions will appear here once available',
              style: TextStyle(fontSize: scale, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    debugPrint("Showing card transactions list with ${provider.purchases.length} items");

    // Remove the Scaffold since this is inside a tab
    return ListView.builder(
      padding: EdgeInsets.all(scale * 0.8),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: provider.purchases.length,
      itemBuilder: (_, index) {
        final item = provider.purchases[index];
        final amount = double.tryParse(item.amount.toString()) ?? 0;
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
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TransactionDetailsScreen(
                    transactionType: 'Card',
                    amount: amount,
                    terminalName: item.terminalName,
                    transactionReference: item.txnRef,
                    date: formattedDate,
                    status: 'SUCCESS',
                    cardType: item.cardType,
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reference and amount row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.txnRef,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '₦${_formatAmount(amount.toStringAsFixed(2))}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TransactionDetailsScreen(
                                transactionType: 'Card',
                                amount: amount,
                                terminalName: item.terminalName,
                                transactionReference: item.txnRef,
                                date: formattedDate,
                                status: 'SUCCESS',
                                cardType: item.cardType,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward_ios, size: 14),
                      ),
                    ],
                  ),

                  /// Terminal name
                  Text(
                    item.terminalName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: scale * 0.1),

                  /// Reference and date/time
                  Text(
                    '${item.txnRef}\n$formattedDate',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatAmount(dynamic raw) {
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
}