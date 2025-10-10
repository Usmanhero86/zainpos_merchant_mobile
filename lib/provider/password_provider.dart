import 'package:flutter/material.dart';

class PasswordProvider with ChangeNotifier {
  bool isLoading = false;

  Future<void> requestOtp(String email, String password, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      // TODO: call your API service here

      // ✅ After success → go to Verify OTP Screen
      Navigator.pushNamed(context, '/verify-otp');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to request OTP: $e")),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String email, String password, String secretKey, String otp, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      // TODO: call your API service here

      // ✅ After success → go to Reset Password Screen
      Navigator.pushNamed(context, '/reset-password');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to verify OTP: $e")),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email, String otp, String secretKey, String newPassword, String confirmPassword, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      // TODO: call your API service here

      // ✅ After success → go back to LoginScreen
      Navigator.pushReplacementNamed(context, '/login');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset successful!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to reset password: $e")),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
