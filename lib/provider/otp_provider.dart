import 'package:flutter/material.dart';
import '../services/api/api_service.dart';
import '../services/models/response_model/resend_password.dart';
import '../services/models/response_model/verify_otp_response.dart';

class OtpProvider extends ChangeNotifier {
  final ApiService apiService;

  OtpProvider({required this.apiService});

  bool _isLoading = false;
  String? _error;
  VerifyOtpResponse? _otpResponse;
  String? _resendMessage;

  bool get isLoading => _isLoading;
  String? get error => _error;
  VerifyOtpResponse? get otpResponse => _otpResponse;
  String? get resendMessage => _resendMessage;
  ResendOtpResponse? _resendOtpResponse;
  ResendOtpResponse? get resendOtpResponse => _resendOtpResponse;


  Future<void> verifyOtp({required String email, required String otp, required String secretKey,}) async {
    _isLoading = true;
    _error = null;
    _resendMessage = null;
    notifyListeners();

    try {
      final response = await apiService.verifyOtp(
        email: email,
        otp: otp,
        secretKey: secretKey,
        password: '',
      );
      _otpResponse = response;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> resendOtp({required String email, required String secretKey,}) async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
  final response = await apiService.resendOtp(
  email: email,
  secretKey: secretKey,
  );
  _resendOtpResponse = response;
  } catch (e) {
  _error = e.toString();
  }

  _isLoading = false;
  notifyListeners();
  }
  }

