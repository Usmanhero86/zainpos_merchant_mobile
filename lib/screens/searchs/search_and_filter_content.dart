import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/screens/searchs/widgets/date_filter.dart';
import '../../provider/serach_Filter_provider.dart';
import '../../widgets/build_filter_dropdown.dart';

class SearchAndFilterContent extends StatefulWidget {
  const SearchAndFilterContent({super.key});

  @override
  State<SearchAndFilterContent> createState() => _SearchAndFilterContentState();
}

class _SearchAndFilterContentState extends State<SearchAndFilterContent> {
  final TextEditingController _searchController = TextEditingController();

  // Filter options
  final List<String> trxnTypes = [
    'All',
    'Payment',
    'Refund',
    'Transfer',
    'Withdrawal',
    'Deposit'
  ];

  final List<String> periods = [
    'All',
    'Today',
    'Yesterday',
    'This Week',
    'Last Week',
    'This Month',
    'Last Month'
  ];

  final List<String> dateFilters = [
    'All',
    'Last 7 days',
    'Last 30 days',
    'Last 90 days',
    'Custom'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final filterProvider = Provider.of<SearchFilterProvider>(context, listen: false);
      filterProvider.setSelectedDate(picked);
    }
  }

  void _applyFilters() {
    final filterProvider = Provider.of<SearchFilterProvider>(context, listen: false);

    // Update the provider with current filter values
    filterProvider.setSearchQuery(_searchController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filters applied successfully'),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  void _clearAllFilters() {
    _searchController.clear();
    final filterProvider = Provider.of<SearchFilterProvider>(context, listen: false);
    filterProvider.clearAllFilters();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Initialize with current filter values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filterProvider = Provider.of<SearchFilterProvider>(context, listen: false);
      _searchController.text = filterProvider.searchQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<SearchFilterProvider>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Clear button
          Row(
            children: [
              Expanded(
                child: Text(
                  'Search & Filter',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (filterProvider.hasActiveFilters)
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Search Section
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search by Trxn ID or Terminal Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                  });
                },
              )
                  : null,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 10),

          // Filter by Trxn Type
          BuildFilterDropdown(
            value: filterProvider.selectedTrxnType,
            items: trxnTypes,
            onChanged: (value) {
              filterProvider.setSelectedTrxnType(value);
            },
            hintText: 'Filter by Trxn Type',
          ),
          const SizedBox(height: 10),

          // Filter by Period
          BuildFilterDropdown(
            value: filterProvider.selectedPeriod,
            items: periods,
            onChanged: (value) {
              filterProvider.setSelectedPeriod(value);
            },
            hintText: 'Filter by Period',
          ),
          const SizedBox(height: 10),

          // Filter by Date
          BuildFilterDropdown(
            value: filterProvider.selectedDateFilter,
            items: dateFilters,
            onChanged: (value) {
              filterProvider.setSelectedDateFilter(value);
              if (value != 'Custom') {
                filterProvider.setSelectedDate(null);
              }
            },
            hintText: 'Filter by Date',
          ),
          const SizedBox(height: 10),

          // Custom Date Picker
          if (filterProvider.selectedDateFilter == 'Custom')
            Column(
              children: [
                DateFilter(
                  selectedDate: filterProvider.selectedDate,
                  onTap: () => _selectDate(context),
                  hintText: 'Select Date',
                  labelText: 'Select Custom Date',
                ),
                const SizedBox(height: 10),
              ],
            ),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}