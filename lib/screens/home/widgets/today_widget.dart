import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/home/widgets/stat_item.dart';
import '../../../provider/home_provider.dart';

Widget todaysStatsCard(HomeProvider homeProvider, double screenWidth) {
  final todaysTransactions = homeProvider.todaysTransactions;
  final todaysTotal = todaysTransactions.fold(0.0, (sum, transaction) {
    return sum + transaction.amountDouble;
  });

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Activity",
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              statItem(
                'Transaction Value',
                'N${todaysTotal.toStringAsFixed(2)}',
                screenWidth,
              ),
              statItem(
                'Transaction Volume',
                todaysTransactions.length.toString(),
                screenWidth,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
