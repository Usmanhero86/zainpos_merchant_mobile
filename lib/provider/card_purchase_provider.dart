import 'package:flutter/foundation.dart';
import 'package:zainpos_merchant_mobile/services/models/response_model/card_purchase_history_response.dart';
import '../services/api/api_service.dart';

class CardPurchaseProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  bool _isLoading = false;
  String? _errorMessage;
  List<CardPurchaseItem> _purchases = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CardPurchaseItem> get purchases => _purchases;

  // Get purchase count for the chip
  int get purchaseCount => _purchases.length;

  Future<void> loadCardPurchases() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint("=== FETCHING CARD PURCHASE HISTORY ===");
      final response = await _api.fetchCardPurchaseHistory();

      debugPrint("Card Purchase Response - Data length: ${response.data.length}");

      _purchases = response.data;

      debugPrint("Card purchases loaded successfully: ${_purchases.length} items");

    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("Card purchase fetch error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
      debugPrint("Card purchase loading completed. isLoading: $_isLoading, error: $_errorMessage, items: ${_purchases.length}");
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    await loadCardPurchases();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}