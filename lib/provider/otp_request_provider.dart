import 'package:flutter/material.dart';
import '../services/api/api_service.dart';

class OtpRequestProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _error;
  bool _otpSent = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get otpSent => _otpSent;

  Future<void> requestOtp(String email, String password) async {
    _isLoading = true;
    _error = null;
    _otpSent = false;
    notifyListeners();

    try {
      await _apiService.requestOtp(email: email, password: password);
      _otpSent = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
