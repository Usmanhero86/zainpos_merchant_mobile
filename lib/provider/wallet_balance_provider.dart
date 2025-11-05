import 'package:flutter/foundation.dart';
import '../services/api/api_service.dart';
import '../services/models/response_model/wallet_balance_response.dart';

class WalletBalanceProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  WalletBalanceResponse? _walletData;
  bool _isLoading = false;
  String _errorMessage = '';

  WalletBalanceResponse? get walletData => _walletData;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Fetch wallet balance using account number from API
  Future<void> fetchWalletBalance(String accountNumber) async {
    _setLoading(true);
    _setError('');

    try {
      final response = await _apiService.getTerminalWalletBalance(accountNumber);

      if (response != null && response.status) {
        _walletData = response;
      } else {
        _setError(response?.message ?? 'Failed to load wallet balance');
      }
    } catch (e) {
      _setError('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Get actual balance value safely
  double get balanceAmount {
    return _walletData?.data?.balanceAmount ?? 0.0;
  }

  /// Get formatted balance string
  String get formattedBalance {
    final currency = _walletData?.data?.currency ?? 'NGN';
    final balance = balanceAmount / 100; // API returns in kobo
    return '$currency ${balance.toStringAsFixed(2)}';
  }
}
