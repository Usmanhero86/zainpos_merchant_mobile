import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/searchs/widgets/date_filter.dart';

import '../../widgets/build_filter_dropdown.dart';

class SearchAndFilterContent extends StatefulWidget {
  const SearchAndFilterContent({super.key});

  @override
  State<SearchAndFilterContent> createState() => _SearchAndFilterContentState();
}
class _SearchAndFilterContentState extends State<SearchAndFilterContent> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedTrxnType;
  String? _selectedPeriod;
  String? _selectedDateFilter;
  DateTime? _selectedDate;

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
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _applyFilters() {
    final Map<String, dynamic> filters = {
      'searchQuery': _searchController.text,
      'trxnType': _selectedTrxnType,
      'period': _selectedPeriod,
      'dateFilter': _selectedDateFilter,
      'customDate': _selectedDate != null ?
      "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}" : null,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filters applied: ${filters.toString()}'),
        duration: const Duration(seconds: 2),
      ),
    );

    // Close the bottom sheet after applying filters
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Search & Filter',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

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
          value: _selectedTrxnType,
          items: trxnTypes,
          onChanged: (value) {
            setState(() {
              _selectedTrxnType = value;
            });
          },
          hintText: 'Filter by Trxn Type',
        ),
        const SizedBox(height: 10),

        // Filter by Period
        BuildFilterDropdown(
          value: _selectedPeriod,
          items: periods,
          onChanged: (value) {
            setState(() {
              _selectedPeriod = value;
            });
          },
          hintText: 'Filter by Period',
        ),
        const SizedBox(height: 10),

        // Filter by Date
        BuildFilterDropdown(
          value: _selectedDateFilter,
          items: dateFilters,
          onChanged: (value) {
            setState(() {
              _selectedDateFilter = value;
              if (value != 'Custom') {
                _selectedDate = null;
              }
            });
          },
          hintText: 'Filter by Date',
        ),
        const SizedBox(height: 10),

        // Custom Date Picker - Only show if Custom is selected from Date filter
        if (_selectedDateFilter == 'Custom')
          Column(
            children: [
              DateFilter(
                selectedDate: _selectedDate,
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
              'Apply',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}