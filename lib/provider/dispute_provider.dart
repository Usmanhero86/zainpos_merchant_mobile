import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/services/models/response_model/dispute_list_response.dart';
import '../services/api/api_service.dart';

class DisputeProvider extends ChangeNotifier {
  bool isLoading = false;
  List<DisputeModel> disputes = [];
  String? errorMessage;

  final ApiService _apiService = ApiService();

  Future<void> fetchDisputes() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getDisputes();
      disputes = response.data;
    } catch (e) {
      errorMessage = "Error: $e";
    }

    isLoading = false;
    notifyListeners();
  }
}
