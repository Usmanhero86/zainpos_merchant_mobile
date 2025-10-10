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
  int get payoutCount => _payoutResponse?.data?.length ?? 0;

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

  /// Refresh button or pull-to-refresh always calls this
  Future<void> refresh() => loadPayoutHistory(forceRefresh: true);

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}