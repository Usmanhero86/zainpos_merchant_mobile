import 'package:flutter/foundation.dart';
import 'package:zainpos_merchant_mobile/services/models/response_model/card_purchase_history_response.dart';
import '../services/api/api_service.dart';

class CardPurchaseProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  bool isLoading = false;
  String? errorMessage;
  List<CardPurchaseItem> purchases = [];

  Future<void> loadCardPurchases() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.fetchCardPurchaseHistory();
      purchases = response.data;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
