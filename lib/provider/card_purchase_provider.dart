import 'package:flutter/foundation.dart';
import 'package:zainpos_merchant_mobile/services/models/response_model/card_purchase_history_response.dart';
import '../services/api/api_service.dart';
import '../services/models/pigmentation.dart';

class CardPurchaseProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  List<CardPurchaseItem> _purchases = [];
  Pagination? _pagination;
  bool _hasMore = true;

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  List<CardPurchaseItem> get purchases => _purchases;
  Pagination? get pagination => _pagination;
  bool get hasMore => _hasMore;
  int get purchaseCount => _purchases.length;

  // Load initial data
  Future<void> loadCardPurchases({
    int page = 1,
    int limit = 25,
    Map<String, String>? queryParams,
    bool refresh = false,
  }) async {
    if (!refresh && _isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    if (refresh) {
      _purchases = [];
      _hasMore = true;
    }
    notifyListeners();

    try {
      debugPrint("=== FETCHING CARD PURCHASE HISTORY ===");
      final response = await _api.fetchCardPurchaseHistory(
        page: page,
        limit: limit,
        queryParams: queryParams,
      );

      if (response.data.isEmpty) {
        debugPrint("Card purchase history is empty");
        _purchases = refresh ? [] : _purchases;
        _hasMore = false;
      } else {
        debugPrint("Card Purchase Response - Data length: ${response.data.length}");

        if (refresh) {
          _purchases = response.data;
        } else {
          _purchases.addAll(response.data);
        }

        _pagination = response.pagination;
        _hasMore = response.hasMoreData;

        debugPrint("Card purchases loaded successfully: ${_purchases.length} items");
        debugPrint("Has more data: $_hasMore");
        debugPrint("Pagination - Page: ${_pagination?.page}, Total: ${_pagination?.totalCount}");

        // Debug first few items
        if (_purchases.isNotEmpty) {
          for (int i = 0; i < (_purchases.length > 3 ? 3 : _purchases.length); i++) {
            debugPrint("Item $i: ${_purchases[i].txnRef} - ${_purchases[i].amount}");
          }
        }
      }

    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("Card purchase fetch error: $e");

      if (e.toString().contains('Failed to load') || e.toString().contains('Exception')) {
        _errorMessage = 'Failed to load card purchase history';
      } else {
        _errorMessage = 'Network error. Please try again.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
      debugPrint("Card purchase loading completed. isLoading: $_isLoading, error: $_errorMessage, items: ${_purchases.length}");
    }
  }

  // Load more data for pagination
  Future<void> loadMorePurchases({
    Map<String, String>? queryParams,
  }) async {
    if (_isLoadingMore || !_hasMore || _pagination == null) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _pagination!.page + 1;
      final limit = _pagination!.limit;

      final response = await _api.fetchCardPurchaseHistory(
        page: nextPage,
        limit: limit,
        queryParams: queryParams,
      );

      if (response.data.isNotEmpty) {
        _purchases.addAll(response.data);
        _pagination = response.pagination;
        _hasMore = response.hasMoreData;

        debugPrint("Loaded more purchases: ${response.data.length} items");
        debugPrint("Total purchases now: ${_purchases.length}");
        debugPrint("Has more data after loading: $_hasMore");
      } else {
        _hasMore = false;
      }

    } catch (e) {
      _errorMessage = 'Failed to load more purchases: $e';
      debugPrint("Load more error: $e");
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Your existing filtering methods...
  List<CardPurchaseItem> getFilteredPurchases(Map<String, dynamic> filters) {
    if (!_hasActiveFilters(filters)) {
      return _purchases;
    }

    return _purchases.where((purchase) {
      final searchQuery = filters['searchQuery'] as String? ?? '';
      if (searchQuery.isNotEmpty) {
        final matchesSearch = purchase.txnRef.toLowerCase().contains(searchQuery.toLowerCase()) ||
            purchase.terminalName.toLowerCase().contains(searchQuery.toLowerCase());
        if (!matchesSearch) return false;
      }

      final trxnType = filters['trxnType'] as String?;
      if (trxnType != null && trxnType != 'All') {
        if (trxnType != 'Payment') return false;
      }

      final period = filters['period'] as String?;
      if (period != null && period != 'All') {
        if (!_matchesPeriod(purchase.txnDate, period)) {
          return false;
        }
      }

      final dateFilter = filters['dateFilter'] as String?;
      final customDate = filters['customDate'] as String?;
      if (dateFilter != null && dateFilter != 'All') {
        if (!_matchesDateFilter(purchase.txnDate, dateFilter, customDate)) {
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

  /// Refresh data
  Future<void> refresh() async {
    await loadCardPurchases(refresh: true);
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear all data
  void clear() {
    _purchases = [];
    _pagination = null;
    _hasMore = true;
    _errorMessage = null;
    notifyListeners();
  }
}