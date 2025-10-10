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
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _showSearchContainer = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => context.read<BankDepositHistoryProvider>().fetchBankDeposits(),
    );
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text;

    // Call the provider's search method
    if (_selectedFilter == 0) {
      context.read<BankDepositHistoryProvider>().searchDeposits(query);
    }
    // TODO: Add search for other filters when their providers are implemented

    setState(() {
      _isSearching = query.isNotEmpty;
    });
  }

  void _toggleSearchContainer() {
    setState(() {
      _showSearchContainer = !_showSearchContainer;
      if (!_showSearchContainer) {
        _clearSearch();
      } else {
        // Focus on search field when container appears
        Future.delayed(const Duration(milliseconds: 300), () {
          FocusScope.of(context).requestFocus(FocusNode());
        });
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _isSearching = false;

      // Clear search in the provider
      if (_selectedFilter == 0) {
        context.read<BankDepositHistoryProvider>().clearSearch();
      }
      // TODO: Clear search in other providers when implemented

      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        title: _isSearching
            ? Consumer<BankDepositHistoryProvider>(
          builder: (context, provider, _) {
            final stats = provider.searchStats;
            return Text(
              'Search Results (${stats['filtered']})',
              style: TextStyle(
                fontSize: scale * 1.2,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            );
          },
        )
            : Text(
          'Transactions',
          style: TextStyle(
            fontSize: scale * 1.2,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear, size: 24, color: Colors.blue),
              onPressed: _clearSearch,
            )
          else
            IconButton(
              icon: const Icon(Icons.search, size: 24, color: Colors.blue),
              onPressed: _toggleSearchContainer,
            ),
        ],
      ),
      body: Column(
        children: [
          // Animated Search Container
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showSearchContainer ? 80 : 0,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: _showSearchContainer ? 16 : 0,
            ),
            child: _showSearchContainer
                ? Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: _getSearchHintText(),
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey[600],
                        size: 18,
                      ),
                      onPressed: _clearSearch,
                    ),
                  const SizedBox(width: 8),
                ],
              ),
            )
                : const SizedBox.shrink(),
          ),

          // Search info banner
          if (_isSearching && _searchController.text.isNotEmpty)
            Consumer<BankDepositHistoryProvider>(
              builder: (context, provider, _) {
                final stats = provider.searchStats;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: 8,
                    ),
                    color: Colors.blue[50],
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue[700], size: 16),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: Text(
                            'Found ${stats['filtered']} of ${stats['total']} transactions for "${_searchController.text}"',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: _clearSearch,
                          child: Text(
                            'Clear',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

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
                    _clearSearch(); // Clear search when switching filters
                    context.read<BankDepositHistoryProvider>().fetchBankDeposits();
                  },
                ),
                SizedBox(width: scale * 0.6),
                CustomFilterChip(
                  label: 'Card',
                  selected: _selectedFilter == 1,
                  onTap: () {
                    setState(() => _selectedFilter = 1);
                    _clearSearch(); // Clear search when switching filters
                    // TODO: Fetch card transactions
                  },
                ),
                SizedBox(width: scale * 0.6),
                CustomFilterChip(
                  label: 'Payout',
                  selected: _selectedFilter == 2,
                  onTap: () {
                    setState(() => _selectedFilter = 2);
                    _clearSearch(); // Clear search when switching filters
                    // TODO: Fetch payout transactions
                  },
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
                      final depositsToShow = bankProvider.searchQuery.isNotEmpty
                          ? bankProvider.filteredDeposits
                          : bankProvider.deposits;

                      // Debug: Print the first item to see its structure
                      if (depositsToShow.isNotEmpty) {
                        print('First item type: ${depositsToShow.first.runtimeType}');
                        print('First item amountAfterCharges: ${depositsToShow.first.amountAfterCharges}');
                        print('First item type: ${depositsToShow.first.amountAfterCharges.runtimeType}');
                      }

                      if (bankProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (bankProvider.error != null) {
                        return Center(
                          child: Text(
                            'Error: ${bankProvider.error}',
                            style: TextStyle(fontSize: scale),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      if (depositsToShow.isEmpty) {
                        return _buildEmptyState(
                          isSearching: _isSearching,
                          searchQuery: _searchController.text,
                          screenWidth: screenWidth,
                          filterType: 'POS Transfer',
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          _clearSearch();
                          if (_showSearchContainer) {
                            setState(() {
                              _showSearchContainer = false;
                            });
                          }
                          return bankProvider.refresh();
                        },
                        child: TransactionsList(data: depositsToShow),
                      );
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

  String _getSearchHintText() {
    switch (_selectedFilter) {
      case 0: // POS Transfer
        return 'Search by amount, account, bank, reference, terminal...';
      case 1: // Card
        return 'Search by card number, amount, status...';
      case 2: // Payout
        return 'Search by recipient, amount, status...';
      default:
        return 'Search transactions...';
    }
  }

  Widget _buildEmptyState({required bool isSearching, required String searchQuery, required double screenWidth, required String filterType,}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.receipt_long,
            size: screenWidth * 0.15,
            color: Colors.grey[400],
          ),
          SizedBox(height: screenWidth * 0.04),
          Text(
            isSearching
                ? 'No $filterType transactions found for "$searchQuery"'
                : 'No $filterType transactions available',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (isSearching)
            TextButton(
              onPressed: _clearSearch,
              child: const Text('Clear search'),
            ),
        ],
      ),
    );
  }
}