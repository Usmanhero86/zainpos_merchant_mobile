// lib/provider/home_provider.dart
import 'package:flutter/foundation.dart';
import 'package:zainpos_merchant_mobile/services/models/response_model/home_response.dart';

import '../services/api/api_service.dart';

class HomeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  HomeResponse? _homeData;
  bool _isLoading = false;
  String _errorMessage = '';

  HomeResponse? get homeData => _homeData;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  Future<void> fetchHomeData() async {
    _setLoading(true);
    _setError('');

    try {
      _homeData = await _apiService.fetchHomeData();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to load home data: ${e.toString()}');
      _setLoading(false);
    }
  }

  // Get total balance (sum of all settled amounts)
  double get totalBalance {
    if (_homeData == null) return 0.0;

    return _homeData!.recentTransactions.fold(0.0, (sum, transaction) {
      return sum + transaction.settledAmountDouble;
    });
  }

  // Get today's transactions
  List<RecentTransaction> get todaysTransactions {
    if (_homeData == null) return [];

    final today = DateTime.now();
    return _homeData!.recentTransactions.where((transaction) {
      return transaction.parsedDate.year == today.year &&
          transaction.parsedDate.month == today.month &&
          transaction.parsedDate.day == today.day;
    }).toList();
  }

  // Get active terminals
  List<Terminal> get activeTerminals {
    if (_homeData == null) return [];

    return _homeData!.terminals.where((terminal) => terminal.isActive).toList();
  }

  void refreshData() {
    _homeData = null;
    fetchHomeData();
  }
}