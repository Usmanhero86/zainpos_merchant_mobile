import 'package:flutter/foundation.dart';
import 'package:zainpos_merchant_mobile/services/models/response_model/bank_deposit_history_response.dart';
import '../services/api/api_service.dart';

class BankDepositHistoryProvider extends ChangeNotifier {
  final ApiService _apiService;

  BankDepositHistoryProvider({required ApiService apiService})
      : _apiService = apiService;

  bool _isLoading = false;
  String? _error;
  List<BankDepositItem> _deposits = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<BankDepositItem> get deposits => _deposits;

  /// Fetch bank deposit history from API
  Future<void> fetchBankDeposits() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final BankDepositHistoryResponse response =
      await _apiService.fetchBankDepositHistory();
      _deposits = response.data;
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
}
