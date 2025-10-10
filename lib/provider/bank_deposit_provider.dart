import 'package:flutter/foundation.dart';
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
        if (deposit.beneficiaryAccountNumber.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        // Search by beneficiary account name
        if (deposit.beneficiaryAccountName.toLowerCase().contains(lowerCaseQuery)) {
          return true;
        }

        // Search by beneficiary bank name
        if (deposit.beneficiaryBankName.toLowerCase().contains(lowerCaseQuery)) {
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
        if (deposit.senderAccountNumber.toLowerCase().contains(lowerCaseQuery)) {
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
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
      return deposit.beneficiaryBankName.toLowerCase().contains(bankName.toLowerCase()) ||
          deposit.senderBankName.toLowerCase().contains(bankName.toLowerCase());
    }).toList();
  }
}