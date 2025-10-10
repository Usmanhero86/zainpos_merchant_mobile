import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/terminal/widgets/transaction_list.dart';
import 'package:zainpos_merchant_mobile/screens/transactions/widgets/transaction_list.dart';
import '../../services/api/api_service.dart';
import '../../services/models/response_model/home_response.dart';
import '../../widgets/currency_converter.dart';
import '../../widgets/settings_bottom_sheet.dart';
import '../home/tabs/transaction_screen.dart';
import '../transactions/card_transaction_screen.dart';
import '../transactions/payout_transaction_screen.dart';

class TerminalDetailScreen extends StatefulWidget {
  final Terminal terminal;

  const TerminalDetailScreen({super.key, required this.terminal});

  @override
  State<TerminalDetailScreen> createState() => _TerminalDetailScreenState();
}

class _TerminalDetailScreenState extends State<TerminalDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoadingBalance = true;
  String walletBalance = "0.00";
  String? balanceError;

  @override
  void initState() {
    super.initState();
    getBalance();
    _tabController = TabController(length: 3, vsync: this);
  }

  void getBalance() async {
    setState(() {
      isLoadingBalance = true;
      balanceError = null;
    });
    try {
      final apiService = ApiService();
      final response = await apiService.getTerminalWalletBalance(
        widget.terminal.virtualAccountNumber!,
      );

      setState(() {
        if (response != null) {
          walletBalance = CurrencyFormatter.getAmountWithCurrency(
            response.data.balanceAmount,
          );
        } else {
          walletBalance = "₦0.00";
          balanceError = "Failed to load balance";
        }
        isLoadingBalance = false;
      });
    } catch (e) {
      setState(() {
        walletBalance = "₦0.00";
        balanceError = "Failed to load balance";
        isLoadingBalance = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // getBalance();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.terminal.businessName ?? "N/A",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Terminal Info Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Combined Virtual Account Number and Wallet Balance
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    children: [
                      // Virtual Account Number
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance,
                            color: Colors.blue[600],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Virtual Account Number',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.terminal.virtualAccountNumber ?? "N/A",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Wallet Balance
                      Row(
                        children: [
                          Icon(Icons.wallet, color: Colors.blue[600], size: 20),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wallet Balance',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  if (isLoadingBalance)
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                          Colors.blue,
                                        ),
                                      ),
                                    )
                                  else
                                    Text(
                                      walletBalance,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color:
                                        balanceError != null
                                            ? Colors.red
                                            : Colors.black87,
                                      ),
                                    ),
                                  if (balanceError != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.refresh,
                                          size: 16,
                                        ),
                                        onPressed: getBalance,
                                        color: Colors.blue[600],
                                        tooltip: 'Retry loading balance',
                                      ),
                                    ),
                                ],
                              ),
                              if (balanceError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Tap refresh to retry',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),

                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Recent Transactions Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to all transactions
                  },
                  child: const Text(
                    '15 Transactions',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'POS Transfer'),
                Tab(text: 'Card'),
                Tab(text: 'Payout'),
              ],
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TransactionList(),
                CardTransactionsScreen(),
                PayoutTransactionsScreen(),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PayoutTransactionsScreen()),
            );
          },
          backgroundColor: Colors.blue,
          child: Icon(Icons.send_sharp,
            color: Colors.white,
            size: 20,)
      ),
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SettingsBottomSheet(terminal: widget.terminal),
    );
  }
}