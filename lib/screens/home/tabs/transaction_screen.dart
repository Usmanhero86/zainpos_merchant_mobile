import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/screens/transactions/payout_transaction_screen.dart';
import '../../transactions/card_transaction_screen.dart';
import '../../transactions/widgets/filter_chip.dart';
import '../../transactions/widgets/transaction_list.dart';
import 'package:zainpos_merchant_mobile/provider/bank_deposit_provider.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int _selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => context.read<BankDepositHistoryProvider>().fetchBankDeposits(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Transactions',
          style: TextStyle(
            fontSize: scale * 1.2,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: scale * 1.2, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          /// Filter chips
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: scale * 0.8,
              vertical: scale * 0.5,
            ),
            child: Row(
              children: [
                CustomFilterChip(
                  label: 'POS Transfer',
                  selected: _selectedFilter == 0,
                  onTap: () {
                    setState(() => _selectedFilter = 0);
                    context.read<BankDepositHistoryProvider>().fetchBankDeposits();
                  },
                ),
                SizedBox(width: scale * 0.6),
                CustomFilterChip(
                  label: 'Card',
                  selected: _selectedFilter == 1,
                  onTap: () => setState(() => _selectedFilter = 1),
                ),
                SizedBox(width: scale * 0.6),
                CustomFilterChip(
                  label: 'Payout',
                  selected: _selectedFilter == 2,
                  onTap: () => setState(() => _selectedFilter = 2),
                ),
              ],
            ),
          ),

          /// Dynamic content
          Expanded(
            child: Builder(
              builder: (context) {
                if (_selectedFilter == 0) {
                  return Consumer<BankDepositHistoryProvider>(
                    builder: (context, bankProvider, _) {
                      if (bankProvider.error != null) {
                        return Center(
                          child: Text(
                            'Error: ${bankProvider.error}',
                            style: TextStyle(fontSize: scale),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      if (bankProvider.deposits.isEmpty) {
                        return Center(
                          child: Text(
                            'No deposits found',
                            style: TextStyle(fontSize: scale),
                          ),
                        );
                      }
                      return TransactionsList(data: bankProvider.deposits);
                    },
                  );
                } else if (_selectedFilter == 1) {
                  return const CardTransactionsScreen();
                } else {
                  return const PayoutTransactionsScreen();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
