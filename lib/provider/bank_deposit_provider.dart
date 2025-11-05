import 'package:flutter/foundation.dart';
import 'package:zainpos_merchant_mobile/provider/serach_Filter_provider.dart';
import 'package:zainpos_merchant_mobile/services/models/response_model/bank_deposit_history_response.dart';
import '../services/api/api_service.dart';

class BankDepositHistoryProvider with ChangeNotifier {
  final ApiService _apiService;

  BankDepositHistoryProvider({required ApiService apiService})
      : _apiService = apiService;

  bool _isLoading = false;
  String? _error;
  List<BankDepositItem> _deposits = [];
  List<BankDepositItem> _filteredDeposits = [];
  String _searchQuery = '';

  // Getters
  bool get isLoading => _isLoading;

  String? get error => _error;

  List<BankDepositItem> get deposits => _deposits;

  List<BankDepositItem> get filteredDeposits => _filteredDeposits;

  String get searchQuery => _searchQuery;

  // Add this getter for deposit count
  int get depositCount => _deposits.length;

  /// Fetch bank deposit history from API
  Future<void> fetchBankDeposits() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final BankDepositHistoryResponse response =
      await _apiService.fetchBankDepositHistory();
      _deposits = response.data;
      _filteredDeposits = _deposits;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Bank deposit fetch error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search deposits by various fields based on actual BankDepositItem structure
  void searchDeposits(String query) {
    _searchQuery = query;

    if (query.isEmpty) {
      _filteredDeposits = _deposits;
    } else {
      final lowerCaseQuery = query.toLowerCase();
      _filteredDeposits = _deposits.where((deposit) {
        // Search by deposited amount
        if (deposit.depositedAmount.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        // Search by transaction charges amount
        if (deposit.txnChargesAmount.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        // Search by amount after charges
        if (deposit.amountAfterCharges.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        // Search by beneficiary account number
        if (deposit.beneficiaryAccountNumber.toLowerCase().contains(
            lowerCaseQuery)) {
          return true;
        }

        // Search by beneficiary account name
        if (deposit.beneficiaryAccountName.toLowerCase().contains(
            lowerCaseQuery)) {
          return true;
        }

        // Search by beneficiary bank name
        if (deposit.beneficiaryBankName.toLowerCase().contains(
            lowerCaseQuery)) {
          return true;
        }

        // Search by sender bank name
        if (deposit.senderBankName.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        // Search by sender account name
        if (deposit.senderAccountName.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        // Search by sender account number
        if (deposit.senderAccountNumber.toLowerCase().contains(
            lowerCaseQuery)) {
          return true;
        }

        // Search by narration
        if (deposit.narration.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        // Search by transaction reference
        if (deposit.txnRef.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        // Search by payment reference
        if (deposit.paymentReference.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        // Search by terminal ID
        if (deposit.terminalId.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        // Search by terminal name
        if (deposit.terminalName.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        // Search by zainbox code
        if (deposit.zainboxCode.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        // Search by date (format dates to string for searching)
        final txnDateString = _formatDateForSearch(deposit.txnDate);
        if (txnDateString.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        final paymentDateString = _formatDateForSearch(deposit.paymentDate);
        if (paymentDateString.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        final createdAtString = _formatDateForSearch(deposit.createdAt);
        if (createdAtString.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        return false;
      }).toList();
    }

    notifyListeners();
  }

  /// Format date for search (multiple formats to improve searchability)
  String _formatDateForSearch(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day
        .toString().padLeft(2, '0')}';
  }

  /// Clear search and show all deposits
  void clearSearch() {
    _searchQuery = '';
    _filteredDeposits = _deposits;
    notifyListeners();
  }

  /// Get search statistics
  Map<String, dynamic> get searchStats {
    return {
      'total': _deposits.length,
      'filtered': _filteredDeposits.length,
      'query': _searchQuery,
      'isSearching': _searchQuery.isNotEmpty,
    };
  }

  /// Get available search fields for UI hints
  List<String> get searchableFields {
    return [
      'Amount',
      'Account Number',
      'Account Name',
      'Bank Name',
      'Reference',
      'Narration',
      'Terminal',
      'Date',
    ];
  }

  /// Refresh data
  Future<void> refresh() async {
    await fetchBankDeposits();
  }

  /// Get filtered deposits by date range (additional utility method)
  List<BankDepositItem> getDepositsByDateRange(DateTime start, DateTime end) {
    return _deposits.where((deposit) {
      return deposit.txnDate.isAfter(start) && deposit.txnDate.isBefore(end);
    }).toList();
  }

  /// Get deposits by terminal
  List<BankDepositItem> getDepositsByTerminal(String terminalId) {
    return _deposits.where((deposit) {
      return deposit.terminalId.toLowerCase() == terminalId.toLowerCase();
    }).toList();
  }

  /// Get deposits by bank
  List<BankDepositItem> getDepositsByBank(String bankName) {
    return _deposits.where((deposit) {
      return deposit.beneficiaryBankName.toLowerCase().contains(
          bankName.toLowerCase()) ||
          deposit.senderBankName.toLowerCase().contains(bankName.toLowerCase());
    }).toList();
  }

  // Add these methods to your BankDepositHistoryProvider
// In your BankDepositHistoryProvider, update the getFilteredDeposits method:
  List<BankDepositItem> getFilteredDeposits(Map<String, dynamic> filters) {
    if (!_hasActiveFilters(filters)) {
      return deposits;
    }

    return deposits.where((deposit) {
      // Search by transaction reference or terminal name
      final searchQuery = filters['searchQuery'] as String? ?? '';
      if (searchQuery.isNotEmpty) {
        final matchesSearch = deposit.txnRef.toLowerCase().contains(
            searchQuery.toLowerCase()) ||
            deposit.terminalName.toLowerCase().contains(
                searchQuery.toLowerCase());
        if (!matchesSearch) return false;
      }

      // Filter by transaction type
      final trxnType = filters['trxnType'] as String?;
      if (trxnType != null && trxnType != 'All') {
        final transactionType = _mapToTransactionType(deposit);
        if (transactionType != trxnType) return false;
      }

      // Filter by period
      final period = filters['period'] as String?;
      if (period != null && period != 'All') {
        if (!_matchesPeriod(deposit.txnDate, period)) {
          return false;
        }
      }

      // Filter by date range
      final dateFilter = filters['dateFilter'] as String?;
      final customDate = filters['customDate'] as String?;
      if (dateFilter != null && dateFilter != 'All') {
        if (!_matchesDateFilter(deposit.txnDate, dateFilter, customDate)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  bool _hasActiveFilters(Map<String, dynamic> filters) {
    final searchQuery = filters['searchQuery'] as String? ?? '';
    final trxnType = filters['trxnType'] as String?;
    final period = filters['period'] as String?;
    final dateFilter = filters['dateFilter'] as String?;

    return searchQuery.isNotEmpty ||
        (trxnType != null && trxnType != 'All') ||
        (period != null && period != 'All') ||
        (dateFilter != null && dateFilter != 'All');
  }

  String _mapToTransactionType(BankDepositItem deposit) {
    // Map your deposit to transaction types
    // Adjust this based on your actual data structure
    // For bank deposits, they are typically transfers
    return 'Transfer';
  }

  bool _matchesPeriod(DateTime transactionDate, String period) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (period) {
      case 'Today':
        return transactionDate.year == today.year &&
            transactionDate.month == today.month &&
            transactionDate.day == today.day;
      case 'Yesterday':
        final yesterday = today.subtract(const Duration(days: 1));
        return transactionDate.year == yesterday.year &&
            transactionDate.month == yesterday.month &&
            transactionDate.day == yesterday.day;
      case 'This Week':
        final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
        return transactionDate.isAfter(
            startOfWeek.subtract(const Duration(days: 1)));
      case 'Last Week':
        final startOfLastWeek = today.subtract(
            Duration(days: today.weekday + 6));
        final endOfLastWeek = startOfLastWeek.add(const Duration(days: 6));
        return transactionDate.isAfter(
            startOfLastWeek.subtract(const Duration(days: 1))) &&
            transactionDate.isBefore(
                endOfLastWeek.add(const Duration(days: 1)));
      case 'This Month':
        return transactionDate.year == today.year &&
            transactionDate.month == today.month;
      case 'Last Month':
        final lastMonth = today.month == 1
            ? DateTime(today.year - 1, 12)
            : DateTime(today.year, today.month - 1);
        return transactionDate.year == lastMonth.year &&
            transactionDate.month == lastMonth.month;
      default:
        return true;
    }
  }

  bool _matchesDateFilter(DateTime transactionDate, String dateFilter,
      String? customDate) {
    final now = DateTime.now();

    switch (dateFilter) {
      case 'Last 7 days':
        final sevenDaysAgo = now.subtract(const Duration(days: 7));
        return transactionDate.isAfter(sevenDaysAgo);
      case 'Last 30 days':
        final thirtyDaysAgo = now.subtract(const Duration(days: 30));
        return transactionDate.isAfter(thirtyDaysAgo);
      case 'Last 90 days':
        final ninetyDaysAgo = now.subtract(const Duration(days: 90));
        return transactionDate.isAfter(ninetyDaysAgo);
      case 'Custom':
        if (customDate != null) {
          try {
            final customDateTime = DateTime.parse(customDate);
            return transactionDate.year == customDateTime.year &&
                transactionDate.month == customDateTime.month &&
                transactionDate.day == customDateTime.day;
          } catch (e) {
            return false;
          }
        }
        return false;
      default:
        return true;
    }

    String _mapToTransactionType(BankDepositItem deposit) {
      // Map your deposit to transaction types
      // Adjust this based on your actual data structure
      return 'Transfer'; // Example - adjust as needed
    }

    bool _matchesPeriod(DateTime transactionDate, String period) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      switch (period) {
        case 'Today':
          return transactionDate.year == today.year &&
              transactionDate.month == today.month &&
              transactionDate.day == today.day;
        case 'Yesterday':
          final yesterday = today.subtract(const Duration(days: 1));
          return transactionDate.year == yesterday.year &&
              transactionDate.month == yesterday.month &&
              transactionDate.day == yesterday.day;
        case 'This Week':
          final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
          return transactionDate.isAfter(
              startOfWeek.subtract(const Duration(days: 1)));
        case 'Last Week':
          final startOfLastWeek = today.subtract(
              Duration(days: today.weekday + 6));
          final endOfLastWeek = startOfLastWeek.add(const Duration(days: 6));
          return transactionDate.isAfter(
              startOfLastWeek.subtract(const Duration(days: 1))) &&
              transactionDate.isBefore(
                  endOfLastWeek.add(const Duration(days: 1)));
        case 'This Month':
          return transactionDate.year == today.year &&
              transactionDate.month == today.month;
        case 'Last Month':
          final lastMonth = today.month == 1
              ? DateTime(today.year - 1, 12)
              : DateTime(today.year, today.month - 1);
          return transactionDate.year == lastMonth.year &&
              transactionDate.month == lastMonth.month;
        default:
          return true;
      }
    }

    bool _matchesDateFilter(DateTime transactionDate, String dateFilter,
        DateTime? customDate) {
      final now = DateTime.now();

      switch (dateFilter) {
        case 'Last 7 days':
          final sevenDaysAgo = now.subtract(const Duration(days: 7));
          return transactionDate.isAfter(sevenDaysAgo);
        case 'Last 30 days':
          final thirtyDaysAgo = now.subtract(const Duration(days: 30));
          return transactionDate.isAfter(thirtyDaysAgo);
        case 'Last 90 days':
          final ninetyDaysAgo = now.subtract(const Duration(days: 90));
          return transactionDate.isAfter(ninetyDaysAgo);
        case 'Custom':
          return customDate != null &&
              transactionDate.year == customDate.year &&
              transactionDate.month == customDate.month &&
              transactionDate.day == customDate.day;
        default:
          return true;
      }
    }
  }
}