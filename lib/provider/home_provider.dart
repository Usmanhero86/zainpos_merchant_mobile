import 'package:flutter/foundation.dart';
import 'package:zainpos_merchant_mobile/services/models/response_model/home_response.dart';
import 'package:zainpos_merchant_mobile/services/models/response_model/wallet_balance_response.dart';
import '../services/api/api_service.dart';

class HomeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  HomeResponse? _homeData;
  WalletBalanceData? _walletBalance;
  bool _isLoading = false;
  bool _isWalletLoading = false;
  String _errorMessage = '';

  HomeResponse? get homeData => _homeData;
  WalletBalanceData? get walletBalance => _walletBalance;
  bool get isLoading => _isLoading;
  bool get isWalletLoading => _isWalletLoading;
  String get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setWalletLoading(bool loading) {
    _isWalletLoading = loading;
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

  // === Fetch dashboard home data ===
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

  // === Fetch wallet balance using account number ===
  Future<void> fetchWalletBalance(String accountNumber) async {
    if (accountNumber.isEmpty) {
      _setError('Account number is required to fetch wallet balance');
      return;
    }

    _setWalletLoading(true);
    _setError('');

    try {
      final response = await _apiService.getTerminalWalletBalance(accountNumber);

      if (response != null && response.status && response.data != null) {
        _walletBalance = response.data!;
      } else {
        _walletBalance = null;
        _setError(response?.message ?? 'Failed to load wallet balance');
      }
    } catch (e) {
      _walletBalance = null;
      _setError('Error fetching wallet balance: $e');
    } finally {
      _setWalletLoading(false);
    }
  }

  // === Get actual wallet balance (primary) ===
  double get totalBalance {
    // Always prefer the real API wallet balance
    if (_walletBalance != null) {
      return _walletBalance!.balanceAmount;
    }

    // Fallback to home data if wallet balance is not available
    if (_homeData == null) return 0.0;

    return _homeData!.recentTransactions.fold(0.0, (sum, transaction) {
      return sum + transaction.settledAmountDouble;
    });
  }

  // === Get formatted balance for display ===
  String get formattedBalance {
    final balance = totalBalance / 100;
    return '₦${balance.toStringAsFixed(2)}';
  }

  // === Check if we have real wallet balance data ===
  bool get hasRealWalletBalance => _walletBalance != null;

  // === Get today's transactions ===
  List<RecentTransaction> get todaysTransactions {
    if (_homeData == null) return [];

    final today = DateTime.now();
    return _homeData!.recentTransactions.where((transaction) {
      return transaction.parsedDate.year == today.year &&
          transaction.parsedDate.month == today.month &&
          transaction.parsedDate.day == today.day;
    }).toList();
  }

  // === Active terminals ===
  List<Terminal> get activeTerminals {
    if (_homeData == null) return [];
    return _homeData!.terminals.where((terminal) => terminal.isActive).toList();
  }

  Future<void> refreshData() async {
    _homeData = null;
    _walletBalance = null;
    await fetchHomeData();
  }

  // === Refresh wallet balance only ===
  Future<void> refreshWalletBalance(String accountNumber) async {
    await fetchWalletBalance(accountNumber);
  }
}