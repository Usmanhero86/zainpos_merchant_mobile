import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/provider/card_payment_provider.dart';
import 'package:zainpos_merchant_mobile/screens/banks/widget/bank_row.dart';

class CardPaymentScreen extends StatefulWidget {
  const CardPaymentScreen({super.key});

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterBanks);

    // Fetch data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CardPaymentProvider>().fetchCardSuccessRates();
    });
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_filterBanks)
      ..dispose();
    super.dispose();
  }

  void _filterBanks() {
    final query = _searchController.text.toLowerCase();
    final provider = Provider.of<CardPaymentProvider>(context, listen: false);
    provider.setSearchQuery(query);
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _searchController.clear();
        final provider = Provider.of<CardPaymentProvider>(context, listen: false);
        provider.clearSearch();
      }
    });
  }

  void _handleSearch(String query) {
    final provider = Provider.of<CardPaymentProvider>(context, listen: false);
    provider.setSearchQuery(query.toLowerCase());
  }

  void _clearSearch() {
    _searchController.clear();
    final provider = Provider.of<CardPaymentProvider>(context, listen: false);
    provider.clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: _showSearchBar
            ? IconButton(
          icon: Icon(Icons.arrow_back, size: w * 0.07, color: Colors.black87),
          onPressed: () {
            setState(() {
              _showSearchBar = false;
              _searchController.clear();
              final provider = Provider.of<CardPaymentProvider>(context, listen: false);
              provider.clearSearch();
            });
          },
        )
            : IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: _showSearchBar
            ? Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search banks...',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: _clearSearch,
              ),
            ),
            onChanged: _handleSearch,
          ),
        )
            : Text(
          'Back to Network',
          style: TextStyle(color: Colors.black38),
        ),
        elevation: 0,
        actions: _showSearchBar
            ? [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: _toggleSearchBar,
          ),
        ]
            : [
          IconButton(
            onPressed: _toggleSearchBar,
            icon: Image.asset(
              "assets/logos/searchIcon.png",
              height: 24,
              width: 24,
            ),
          ),
        ],
      ),
      body: Consumer<CardPaymentProvider>(
        builder: (context, provider, child) {
          final displayRates = provider.searchQuery.isEmpty
              ? provider.successRates
              : provider.filteredSuccessRates;

          return Column(
            children: [
              // Table Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Card Payment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Mcard',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Verve',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Visa',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              // Search Results Info
              if (provider.searchQuery.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.blue.shade50,
                  child: Row(
                    children: [
                      Text(
                        'Showing results for "${provider.searchQuery}"',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${displayRates.length} found',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),

              // Loading Indicator
              if (provider.isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              // Error State
              if (!provider.isLoading && provider.successRates.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load data',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            provider.fetchCardSuccessRates();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),

              // No Search Results
              if (!provider.isLoading &&
                  provider.searchQuery.isNotEmpty &&
                  displayRates.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No banks found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try a different search term',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Table Content
              if (!provider.isLoading && displayRates.isNotEmpty)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await provider.refreshData();
                    },
                    child: ListView.separated(
                      itemCount: displayRates.length,
                      itemBuilder: (context, index) {
                        final rate = displayRates[index];
                        return BankRow(rate: rate);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}