import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/home/widgets/placeholder_widget.dart';
import '../../../provider/home_provider.dart';
import 'list_widget.dart';

Widget homeContent(HomeProvider homeProvider, double screenWidth, double screenHeight, double padding) {
  final homeData = homeProvider.homeData!;
  final recentTransactions = homeData.recentTransactions;
  final totalBalance = homeProvider.totalBalance;
  return SingleChildScrollView(
    padding: EdgeInsets.all(padding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: (){},
          style: TextButton.styleFrom(
              minimumSize: Size(250, 40),
              padding: EdgeInsets.symmetric(horizontal: 16),
              side: BorderSide(color: Colors.blue)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.business, color: Colors.blue),
              SizedBox(width: padding - 11),
              Text(
                'Gidado Mustapha Enterprises',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),

        // SizedBox(height: 20),

        // Wallet Balance Card
        // walletBalanceCard(totalBalance, screenWidth),

        // SizedBox(height: 20),

        // Today's Stats Card
        // todaysStatsCard(homeProvider, screenWidth),

        SizedBox(height: 20),

        // Recent Transactions Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )
            ),
            TextButton(
                onPressed: (){},
                child: Text(
                    '${recentTransactions.length} Transactions',
                    style: TextStyle(color: Colors.blue)
                )
            )
          ],
        ),
        SizedBox(height: 16),

        // Transactions List
        if (recentTransactions.isEmpty)
          noTransactionsPlaceholder(screenWidth)
        else
          ...transactionsList(recentTransactions),
      ],
    ),
  );
}
