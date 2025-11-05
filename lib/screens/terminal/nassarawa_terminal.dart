import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/screens/terminal/widgets/show_filter.dart';
import 'package:zainpos_merchant_mobile/screens/terminal/widgets/show_settings.dart';
import 'package:zainpos_merchant_mobile/screens/transactions/payout_transaction_screen.dart';
import 'package:zainpos_merchant_mobile/screens/transfers/transfer_screen.dart';
import '../../provider/bank_deposit_provider.dart';
import '../../provider/card_purchase_provider.dart';
import '../../provider/payout_provider.dart';
import '../../provider/serach_Filter_provider.dart';
import '../../provider/settings_provider.dart';
import '../../services/api/api_service.dart';
import '../../services/models/response_model/terminal_response.dart';
import '../../services/models/response_model/wallet_balance_response.dart';
import '../transactions/widgets/card_transaction_list.dart';
import '../transactions/widgets/transaction_list.dart';

class NassarawaTerminalScreen extends StatefulWidget {
  final Terminals terminal;

  const NassarawaTerminalScreen({super.key, required this.terminal});

  @override
  State<NassarawaTerminalScreen> createState() =>
      _NassarawaTerminalScreenState();
}

class _NassarawaTerminalScreenState extends State<NassarawaTerminalScreen> with SingleTickerProviderStateMixin {
  WalletBalanceResponse? _walletBalance;
  bool _isLoadingBalance = true;
  bool _obscureBalance = true;
  String _errorMessage = '';
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
      }
    });

    Future.microtask(() {
      debugPrint("=== INITIALIZING TERMINAL SCREEN ===");

      Provider.of<BankDepositHistoryProvider>(context, listen: false).fetchBankDeposits();

      final cardProvider = Provider.of<CardPurchaseProvider>(context, listen: false);
      debugPrint("Card provider state - isLoading: ${cardProvider.isLoading}, items: ${cardProvider.purchases.length}");
      cardProvider.loadCardPurchases();

      Provider.of<PayoutProvider>(context, listen: false).loadPayoutHistory();
      _fetchWalletBalance();
    });

  }

  Future<void> _fetchWalletBalance() async {
    final accountNumber = widget.terminal.virtualAccountNumber;
    if (accountNumber == null || accountNumber.isEmpty) {
      setState(() {
        _isLoadingBalance = false;
        _errorMessage = 'No virtual account number found for this terminal';
      });
      return;
    }

    try {
      final response = await ApiService().getTerminalWalletBalance(
        accountNumber,
      );
      if (response != null && response.status) {
        setState(() {
          _walletBalance = response;
          _isLoadingBalance = false;
        });
      } else {
        setState(() {
          _isLoadingBalance = false;
          _errorMessage = response?.message ?? 'Failed to load wallet balance';
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingBalance = false;
        _errorMessage = 'Error fetching balance: ${e.toString()}';
      });
    }
  }

  Future<void> _onRefresh() async {
    await _fetchWalletBalance();
    await Provider.of<BankDepositHistoryProvider>(
      context,
      listen: false,
    ).fetchBankDeposits();
    await Provider.of<CardPurchaseProvider>(
      context,
      listen: false,
    ).loadCardPurchases();
    await Provider.of<PayoutProvider>(context, listen: false).refresh();
  }

  void _toggleBalanceVisibility() {
    setState(() => _obscureBalance = !_obscureBalance);
  }

  String _getDisplayBalance(double balanceAmount) {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: true);

    // If balance is disabled in settings, show nothing
    if (!settingsProvider.balanceEnabled) {
      return '••••••';
    }

    // If balance is enabled but user wants to obscure it
    if (_obscureBalance) {
      return '••••••';
    }

    double displayAmount = balanceAmount / 100;
    return '₦${displayAmount.toStringAsFixed(2)}';
  }

  int _getTransactionCount() {
    try {
      switch (_currentTabIndex) {
        case 0:
          return Provider.of<BankDepositHistoryProvider>(
            context,
            listen: false,
          ).deposits.length;
        case 1:
          return Provider.of<CardPurchaseProvider>(
            context,
            listen: false,
          ).purchases.length;
        case 2:
          return Provider.of<PayoutProvider>(
                context,
                listen: false,
              ).payoutResponse?.data.length ??
              0;
        default:
          return 0;
      }
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final basePadding = isTablet ? 24.0 : 16.0;
    final titleSize = isTablet ? 20.0 : 12.0;
    final cardIconSize = isTablet ? 48.0 : 38.0;
    final terminal = widget.terminal;
    final settingsProvider = Provider.of<SettingsProvider>(context);


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Back to Terminals',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
        actions: [
          IconButton(
          onPressed: () => showSearchFilterBottomSheet(context),
          icon: Image.asset('assets/logos/searchIcon.png', height: 24,),),
          IconButton(onPressed: () => showSettingsBottomSheet(context),
            icon: Image.asset('assets/logos/settings-02.png', height: 24,),),
        ],
      ),
      floatingActionButton: settingsProvider.transfersEnabled
          ? FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          final currentBalance = _walletBalance?.data?.balanceAmount ?? 0.0;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TransferScreen(
              walletBalance: currentBalance,
              terminal: widget.terminal,
            )
            ),
          );
        },
        child: Image.asset('assets/logos/sendIcon.png', height: 24, width: 24),
      ) : null,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
                  Text(terminal.terminalName ?? 'Terminal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,),),
              Padding(
                padding: EdgeInsets.all(basePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Virtual Account and Balance Cards
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                      elevation: 1,
                      child: Padding(
                        padding: EdgeInsets.all(basePadding),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/logos/FeaturedIcon(1).png', height: cardIconSize, width: cardIconSize,),
                                SizedBox(width: basePadding),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Virtual Account Number'),
                                      Text(
                                        terminal.virtualAccountNumber ?? 'N/A',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: titleSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: basePadding),
                            Row(
                              children: [
                                Image.asset('assets/logos/FeaturedIconW.png', height: cardIconSize, width: cardIconSize,),
                                SizedBox(width: basePadding),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Wallet Balance'),
                                      if (_isLoadingBalance)
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      else if (_errorMessage.isNotEmpty)
                                        Text(_errorMessage, style: const TextStyle(color: Colors.red,),)
                                      else
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _getDisplayBalance(
                                                  _walletBalance
                                                          ?.data
                                                          ?.balanceAmount ??
                                                      0.0,
                                                ),
                                                style: TextStyle(
                                                  fontSize: titleSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            IconButton(onPressed: _toggleBalanceVisibility,
                                              icon: Icon(_obscureBalance
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: basePadding),

                    // Transactions Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
                        Chip(
                          label: Text('${_getTransactionCount()} Transaction${_getTransactionCount() != 1 ? 's' : ''}',
                            style: const TextStyle(color: Colors.blue),),
                          backgroundColor: const Color(0xFFEAF1FF),
                        ),
                      ],
                    ),

                    SizedBox(height: basePadding / 2),

                    // Tab Section
                    Container(
                      decoration: BoxDecoration(color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          TabBar(
                            padding: EdgeInsets.zero,
                            labelPadding: EdgeInsets.zero,
                            indicatorSize: TabBarIndicatorSize.tab,
                          controller: _tabController,
                          indicator: BoxDecoration(color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.black54,
                          onTap: (index){
                            setState(() {
                              _currentTabIndex = index;
                            });
                          },
                          tabs: const [
                            Tab(text: 'POS Transfer'),
                            Tab(text: 'Card'),
                            Tab(text: 'Fund Transfer'),
                          ],
                        ),
                          Positioned.fill(
                              child: IgnorePointer(
                                child: Row(
                                  children: [
                                    Expanded(child: SizedBox()),
                                    VerticalDivider(width: 1, color: Colors.grey),
                                    Expanded(child: SizedBox()),
                                    VerticalDivider(width: 1, color: Colors.grey),
                                    Expanded(child: SizedBox()),
                                  ],),
                              ))
                      ]
                      ),
                    ),

                    SizedBox(height: basePadding / 2),

              //    TabBarView section
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: [


              Consumer<BankDepositHistoryProvider>(
                builder: (context, provider, _) {
                  final filterProvider = Provider.of<SearchFilterProvider>(context);
                  final filters = {
                    'searchQuery': filterProvider.searchQuery,
                    'trxnType': filterProvider.selectedTrxnType,
                    'period': filterProvider.selectedPeriod,
                    'dateFilter': filterProvider.selectedDateFilter,
                    'customDate': filterProvider.selectedDate != null
                        ? "${filterProvider.selectedDate!.year}-${filterProvider.selectedDate!.month.toString().padLeft(2, '0')}-${filterProvider.selectedDate!.day.toString().padLeft(2, '0')}"
                        : null,
                  };
                  final filteredData = provider.getFilteredDeposits(filters);

                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (filteredData.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            filterProvider.hasActiveFilters
                                ? 'No transactions match your filters'
                                : 'No transactions found',
                            style: TextStyle(color: Colors.grey),
                          ),
                          if (filterProvider.hasActiveFilters)
                            TextButton(
                              onPressed: () {
                                filterProvider.clearAllFilters();
                              },
                              child: Text('Clear Filters'),
                            ),
                        ],
                      ),
                    );
                  }
                  return TransactionsList(data: filteredData);
                },
              ),

              Consumer<CardPurchaseProvider>(
                builder: (context, provider, _) {
                  final filterProvider = Provider.of<SearchFilterProvider>(context);
                  final filters = {
                    'searchQuery': filterProvider.searchQuery,
                    'trxnType': filterProvider.selectedTrxnType,
                    'period': filterProvider.selectedPeriod,
                    'dateFilter': filterProvider.selectedDateFilter,
                    'customDate': filterProvider.selectedDate != null
                        ? "${filterProvider.selectedDate!.year}-${filterProvider.selectedDate!.month.toString().padLeft(2, '0')}-${filterProvider.selectedDate!.day.toString().padLeft(2, '0')}"
                        : null,
                  };
                  final filteredData = provider.getFilteredPurchases(filters);

                  if (provider.isLoading && provider.purchases.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (filteredData.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            filterProvider.hasActiveFilters
                                ? 'No card transactions match your filters'
                                : 'No card transactions found',
                            style: TextStyle(color: Colors.grey),
                          ),
                          if (filterProvider.hasActiveFilters)
                            TextButton(
                              onPressed: () {
                                filterProvider.clearAllFilters();
                              },
                              child: Text('Clear Filters'),
                            ),
                        ],
                      ),
                    );
                  }
                  return CardTransactionsList(provider: provider, filteredData: filteredData);
                },
              ),

              Consumer<PayoutProvider>(
                builder: (context, provider, _) {
                  final filterProvider = Provider.of<SearchFilterProvider>(context);
                  final filters = {
                    'searchQuery': filterProvider.searchQuery,
                    'trxnType': filterProvider.selectedTrxnType,
                    'period': filterProvider.selectedPeriod,
                    'dateFilter': filterProvider.selectedDateFilter,
                    'customDate': filterProvider.selectedDate != null
                        ? "${filterProvider.selectedDate!.year}-${filterProvider.selectedDate!.month.toString().padLeft(2, '0')}-${filterProvider.selectedDate!.day.toString().padLeft(2, '0')}"
                        : null,
                  };
                  final filteredData = provider.getFilteredPayouts(filters);

                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (filteredData.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            filterProvider.hasActiveFilters
                                ? 'No payout transactions match your filters'
                                : 'No payout transactions found',
                            style: TextStyle(color: Colors.grey),
                          ),
                          if (filterProvider.hasActiveFilters)
                            TextButton(
                              onPressed: () {
                                filterProvider.clearAllFilters();
                              },
                              child: Text('Clear Filters'),
                            ),
                        ],
                      ),
                    );
                  }
                  return PayoutTransactionsScreen(filteredData: filteredData);
                },
              ),
            ],
          ),
        ),
        ]
      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
