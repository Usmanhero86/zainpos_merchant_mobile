import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/provider/bank_list_provider.dart';
import 'package:zainpos_merchant_mobile/screens/banks/widget/bank_list_item.dart';
import '../../services/models/response_model/bank_list_model.dart';

class BankSelectionScreen extends StatefulWidget {
  final Function(Bank)? onBankSelected;

  const BankSelectionScreen({super.key, this.onBankSelected});

  @override
  State<BankSelectionScreen> createState() => _BankSelectionScreenState();
}

class _BankSelectionScreenState extends State<BankSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterBanks);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BankListProvider>(context, listen: false);
      if (provider.bankList == null) {
        provider.fetchBankList();
      }
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
    final provider = Provider.of<BankListProvider>(context, listen: false);
    provider.setSearchQuery(query);
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _searchController.clear();
        final provider = Provider.of<BankListProvider>(context, listen: false);
        provider.clearSearch();
      }
    });
  }

  void _handleSearch(String query) {
    final provider = Provider.of<BankListProvider>(context, listen: false);
    provider.setSearchQuery(query.toLowerCase());
  }

  void _clearSearch() {
    _searchController.clear();
    final provider = Provider.of<BankListProvider>(context, listen: false);
    provider.clearSearch();
  }

  int _calculateSuccessRate(String bankName) {
    final hash = bankName.hashCode.abs();
    return 70 + (hash % 30);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    final double bankNameFont = w * 0.04;
    final double ringSize = w * 0.12;
    final double padding = w * 0.04;

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
              final provider = Provider.of<BankListProvider>(context, listen: false);
              provider.clearSearch();
            });
          },
        )
            : IconButton(
          icon: Icon(Icons.arrow_back, size: 24, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: _showSearchBar
            ? SearchBar(
          backgroundColor: WidgetStateProperty.all(Colors.white70),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          controller: _searchController,
          hintText: 'Search banks...',
          onChanged: _handleSearch,
          trailing: [
            IconButton(
              icon: Icon(Icons.close, size: w * 0.05, color: Colors.grey),
              onPressed: _clearSearch,
            ),
          ],
        )
            : Text(
          'Back',
          style: TextStyle(
            color: Colors.black38,
            fontSize: w * 0.045,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        actions: _showSearchBar
            ? [
          IconButton(
            icon: Icon(Icons.close, size: w * 0.06, color: Colors.grey),
            onPressed: _toggleSearchBar,
          ),
        ]
            : [
          IconButton(
            icon: Icon(Icons.search, size: w * 0.06, color: Colors.blue),
            onPressed: _toggleSearchBar,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Bank Transfer',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),

          // Bank List
          Expanded(
            child: Consumer<BankListProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return loadingState(w);
                }

                if (provider.error != null) {
                  return errorState(provider.error!, w, padding);
                }

                if (provider.filteredBanks.isEmpty) {
                  return emptyState(provider.searchQuery.isNotEmpty, w, padding);
                }

                return bankList(provider.filteredBanks, w, bankNameFont, ringSize, padding);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget bankList(List<Bank> banks, double w, double bankNameFont, double ringSize, double padding) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: padding),
      itemCount: banks.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final bank = banks[index];
        return BankListItem(
          bank: bank,
          successRate: _calculateSuccessRate(bank.name),
          ringSize: ringSize,
          fontSize: bankNameFont,
          spacing: w * 0.03,
          onTap: () {
            if (widget.onBankSelected != null) {
              widget.onBankSelected!(bank);
            }
            Navigator.pop(context, bank);
          },
        );
      },
    );
  }

  Widget loadingState(double w) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: 16),
          Text(
            'Loading banks...',
            style: TextStyle(
              fontSize: w * 0.04,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget errorState(String error, double w, double padding) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Failed to load banks',
              style: TextStyle(
                fontSize: w * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              error.length > 100 ? '${error.substring(0, 100)}...' : error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: w * 0.035,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final provider = Provider.of<BankListProvider>(context, listen: false);
                provider.fetchBankList();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyState(bool isSearching, double w, double padding) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.account_balance,
              size: 64,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              isSearching ? 'No banks found' : 'No banks available',
              style: TextStyle(
                fontSize: w * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Try a different search term'
                  : 'Bank list is currently empty',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: w * 0.035,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}