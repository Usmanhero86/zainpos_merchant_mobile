import 'package:flutter/material.dart';
import '../../../provider/card_purchase_provider.dart';
import '../../../services/models/response_model/card_purchase_history_response.dart';
import '../transaction_details_screen.dart' show TransactionDetailsScreen;

class CardTransactionsList extends StatelessWidget {
  final CardPurchaseProvider provider;
  final List<CardPurchaseItem> filteredData;


  const CardTransactionsList({
    super.key,
    required this.provider,
    required this.filteredData,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth * 0.04;
    // Use filteredData instead of provider.purchases
    if (filteredData.isEmpty) {
      return Center(
        child: Text(
          'No card transactions found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(scale * 0.8),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: filteredData.length,
      itemBuilder: (_, index) {
        final item = filteredData[index];
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
                    transactionType: 'Card Purchase',
                    amount: amount,
                    terminalName: item.terminalName,
                    transactionReference: item.txnRef,
                    date: formattedDate,
                    status: 'SUCCESS',
                    settledAmount: null,
                    chargedAmount: null,
                    cardType: null,
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
                        '₦${formatAmount(amount.toStringAsFixed(2))}',
                        style: TextStyle(
                          fontSize: 14,
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
                                transactionType: 'Card Purchase',
                                amount: amount,
                                terminalName: item.terminalName,
                                transactionReference: item.txnRef,
                                date: formattedDate,
                                status: 'SUCCESS',
                                settledAmount: null,
                                chargedAmount: null,
                                cardType: null,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_forward_ios, size: 14),
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
}