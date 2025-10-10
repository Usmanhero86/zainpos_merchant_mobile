import 'package:flutter/foundation.dart';
import '../../services/api/api_service.dart';
import '../services/models/response_model/reset_password_response.dart';

class ResetPasswordProvider extends ChangeNotifier {
  final ApiService apiService;

  ResetPasswordProvider({required this.apiService});

  ResetPasswordResponse? resetResponse;
  String? error;
  bool isLoading = false;

  Future<void> resetPassword({
    required String email,
    required String secretKey,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      resetResponse = await apiService.resetPassword(
        email: email,
        secretKey: secretKey,
        otp: otp,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
