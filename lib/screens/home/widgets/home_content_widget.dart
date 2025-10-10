import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/screens/home/widgets/placeholder_widget.dart';
import 'package:zainpos_merchant_mobile/screens/home/widgets/wallet_widget.dart';
import '../../../provider/home_provider.dart';
import '../../../provider/login_provider.dart';
import 'list_widget.dart';

class HomeContent extends StatelessWidget {
  final HomeProvider homeProvider;
  final double screenWidth;
  final double screenHeight;
  final double padding;

  const HomeContent({
    super.key,
    required this.homeProvider,
    required this.screenWidth,
    required this.screenHeight,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final homeData = homeProvider.homeData!;
    final recentTransactions = homeData.recentTransactions;

    // Get business name from user data
    final businessName = loginProvider.currentUser?.businessName ?? 'Your Business';

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              minimumSize: const Size(250, 40),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              side: const BorderSide(color: Colors.blue),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.business, color: Colors.blue),
                SizedBox(width: padding - 11),
                Text(
                  businessName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Wallet Balance Card
          const WalletBalanceCard(),

          const SizedBox(height: 20),

          // Recent Transactions Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white70,
                  foregroundColor: Colors.blue,
                  elevation: 1,
                ),
                child: Text(
                  '${recentTransactions.length} Transactions',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Transactions List
          if (recentTransactions.isEmpty)
            noTransactionsPlaceholder(screenWidth)
          else
            ...transactionsList(recentTransactions),
        ],
      ),
    );
  }
}