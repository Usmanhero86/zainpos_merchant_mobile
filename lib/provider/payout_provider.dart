import 'package:flutter/foundation.dart';
import '../services/api/api_service.dart';
import '../services/models/response_model/payout_response_model.dart';

class PayoutProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  bool _isLoading = false;
  String? _error;
  PayoutResponseModel? _payoutResponse;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  PayoutResponseModel? get payoutResponse => _payoutResponse;

  // Get payout count for the chip
  int get payoutCount => _payoutResponse?.data.length ?? 0;

  /// Load payouts. If [forceRefresh] is true we always fetch;
  /// otherwise we only fetch if no cache exists.
  Future<void> loadPayoutHistory({bool forceRefresh = false}) async {
    // If we already have data and not forcing, show it immediately
    if (_payoutResponse != null && !forceRefresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.fetchPayoutHistory();
      _payoutResponse = response;
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Payout fetch error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get filtered payouts based on search/filter criteria
  List<PayoutTransferData> getFilteredPayouts(Map<String, dynamic> filters) {
    final payouts = _payoutResponse?.data ?? [];

    if (!_hasActiveFilters(filters)) {
      return payouts;
    }

    return payouts.where((payout) {
      // Search by transaction reference or terminal name
      final searchQuery = filters['searchQuery'] as String? ?? '';
      if (searchQuery.isNotEmpty) {
        final matchesSearch = payout.txnRef.toLowerCase().contains(searchQuery.toLowerCase()) ||
            payout.terminalName.toLowerCase().contains(searchQuery.toLowerCase());
        if (!matchesSearch) return false;
      }

      // Filter by transaction type
      final trxnType = filters['trxnType'] as String?;
      if (trxnType != null && trxnType != 'All') {
        if (trxnType != 'Payout' && trxnType != 'Withdrawal') return false;
      }

      // Filter by period
      final period = filters['period'] as String?;
      if (period != null && period != 'All') {
        if (!_matchesPeriod(payout.txnDate, period)) {
          return false;
        }
      }

      // Filter by date filter
      final dateFilter = filters['dateFilter'] as String?;
      final customDate = filters['customDate'] as String?;
      if (dateFilter != null && dateFilter != 'All') {
        if (!_matchesDateFilter(payout.txnDate, dateFilter, customDate)) {
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
        return transactionDate.isAfter(startOfWeek.subtract(const Duration(days: 1)));
      case 'Last Week':
        final startOfLastWeek = today.subtract(Duration(days: today.weekday + 6));
        final endOfLastWeek = startOfLastWeek.add(const Duration(days: 6));
        return transactionDate.isAfter(startOfLastWeek.subtract(const Duration(days: 1))) &&
            transactionDate.isBefore(endOfLastWeek.add(const Duration(days: 1)));
      case 'This Month':
        return transactionDate.year == today.year && transactionDate.month == today.month;
      case 'Last Month':
        final lastMonth = today.month == 1 ? DateTime(today.year - 1, 12) : DateTime(today.year, today.month - 1);
        return transactionDate.year == lastMonth.year && transactionDate.month == lastMonth.month;
      default:
        return true;
    }
  }

  bool _matchesDateFilter(DateTime transactionDate, String dateFilter, String? customDate) {
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
  }

  /// Refresh button or pull-to-refresh always calls this
  Future<void> refresh() => loadPayoutHistory(forceRefresh: true);

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}