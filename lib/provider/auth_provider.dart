import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/services/api/api_service.dart';
import '../services/models/response_model/login_response.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  String _authToken = '';
  final ApiService _authService = ApiService();

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get authToken => _authToken;
  bool get isLoggedIn => _authToken.isNotEmpty;

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
    _authService.authToken = token;
    notifyListeners();
  }

  // Login method with API
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final LoginResponse response = await _authService.login(
        email: email,
        password: password,
      );

      // Store the token
      _authToken = response.token;
      _authService.authToken = response.token;

      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Request OTP
  Future<bool> requestOtp({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _authService.requestOtp(email: email, password: password);

      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Verify OTP
  Future<bool> verifyOtp({required String email, required String password, required String secretKey, required String otp,}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _authService.verifyOtp(
        email: email,
        password: password,
        secretKey: secretKey,
        otp: otp,
      );

      // OTP verification successful - no token to extract
      // The token should already be set from the initial login
      debugPrint('OTP verification successful: ${response.message}');

      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reset Password
  Future<bool> resetPassword({required String email, required String otp, required String secretKey, required String newPassword, required String confirmPassword,}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _authService.resetPassword(
        email: email,
        otp: otp,
        secretKey: secretKey,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Resend OTP
  Future<bool> resendOtp({required String email, required String secretKey,}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _authService.resendOtp(email: email, secretKey: secretKey);

      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Change Password
  Future<bool> changePassword({required String currentPassword, required String newPassword, required String confirmPassword,}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  void logout() {
    _isLoading = false;
    _errorMessage = '';
    _authToken = '';
    _authService.authToken = null;
    notifyListeners();
  }

  // Check if user is authenticated
  bool get isAuthenticated => _authToken.isNotEmpty;
}