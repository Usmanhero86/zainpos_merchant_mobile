import 'package:flutter/foundation.dart';
import '../services/api/api_service.dart';
import '../services/models/response_model/payout_response_model.dart';

class PayoutProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  bool isLoading = false;
  String? error;

  /// Cached data
  PayoutResponseModel? payoutResponse;

  /// Load payouts. If [forceRefresh] is true we always fetch;
  /// otherwise we only fetch if no cache exists.
  Future<void> loadPayoutHistory({bool forceRefresh = false}) async {
    // If we already have data and not forcing, show it immediately
    if (payoutResponse != null && !forceRefresh) return;

    isLoading = true;
    notifyListeners();

    try {
      final response = await _api.fetchPayoutHistory();
      payoutResponse = response;
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh button or pull-to-refresh always calls this
  Future<void> refresh() => loadPayoutHistory(forceRefresh: true);
}
