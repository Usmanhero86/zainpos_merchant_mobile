import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/screens/dispute/widgets/dispute_item.dart';
import 'package:zainpos_merchant_mobile/provider/dispute_provider.dart';
import '../../services/models/response_model/dispute_list_response.dart';

class DisputeScreen extends StatefulWidget {
  const DisputeScreen({super.key});

  @override
  State<DisputeScreen> createState() => _DisputeScreenState();
}

class _DisputeScreenState extends State<DisputeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _showSearchContainer = false;
  List<DisputeModel> _filteredDisputes = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<DisputeProvider>(context, listen: false).fetchDisputes());
  }

  void _filterDisputes(String query, List<DisputeModel> allDisputes) {
    if (query.isEmpty) {
      setState(() {
        _filteredDisputes = allDisputes;
        _isSearching = false;
      });
      return;
    }

    final lowerCaseQuery = query.toLowerCase();

    setState(() {
      _filteredDisputes = allDisputes.where((dispute) {
        // Search by date (format: 2024-02-16)
        final dateString = dispute.txnDate.toString().split(' ').first;
        if (dateString.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        // Search by amount
        final amountString = dispute.txnAmount.toStringAsFixed(2);
        if (amountString.contains(lowerCaseQuery)) {
          return true;
        }

        // Search by terminal ID
        if (dispute.terminalId.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        // Search by transaction reference (RRN)
        if (dispute.txnRrn.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        // Search by status
        if (dispute.status.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        return false;
      }).toList();
      _isSearching = true;
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
      _filteredDisputes = [];
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
    final provider = Provider.of<DisputeProvider>(context);
    final size = MediaQuery.of(context).size;

    // Determine which list to display
    final disputesToShow = _isSearching ? _filteredDisputes : provider.disputes;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: _isSearching
            ? Text(
          'Search Results (${_filteredDisputes.length})',
          style: TextStyle(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        )
            : Text(
          'Dispute',
          style: TextStyle(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        actions: [
          if (_isSearching)
            IconButton(
              icon: Icon(Icons.clear, size: size.width * 0.06),
              onPressed: _clearSearch,
            )
          else
            IconButton(
              icon: Image.asset(
                'assets/logos/searchIcon.png',
                height: size.width * 0.06,
                width: size.width * 0.06,
              ),
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
              horizontal: size.width * 0.04,
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
                        hintText: 'Search by date, amount, terminal ID...',
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
                      onChanged: (value) => _filterDisputes(value, provider.disputes),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: 8,
                ),
                color: Colors.blue[50],
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue[700], size: 16),
                    SizedBox(width: size.width * 0.02),
                    Expanded(
                      child: Text(
                        'Found ${_filteredDisputes.length} dispute(s) for "${_searchController.text}"',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: size.width * 0.035,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: _clearSearch,
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Disputes list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _clearSearch();
                if (_showSearchContainer) {
                  _toggleSearchContainer();
                }
                return provider.fetchDisputes();
              },
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.errorMessage != null
                  ? Center(child: Text(provider.errorMessage!))
                  : disputesToShow.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: size.width * 0.15,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      _isSearching
                          ? 'No disputes found for "${_searchController.text}"'
                          : 'No disputes available',
                      style: TextStyle(
                        fontSize: size.width * 0.04,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_isSearching)
                      TextButton(
                        onPressed: _clearSearch,
                        child: const Text('Clear search'),
                      ),
                  ],
                ),
              )
                  : ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.01,
                ),
                itemCount: disputesToShow.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[200],
                  thickness: size.width * 0.002,
                  height: size.height * 0.01,
                ),
                itemBuilder: (context, index) {
                  return DisputeItem(
                    dispute: disputesToShow[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}