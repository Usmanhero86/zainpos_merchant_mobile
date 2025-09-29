import 'package:flutter/foundation.dart';
import '../services/api/api_service.dart';
import '../services/models/response_model/change_password_response_model.dart';

class ChangePasswordProvider extends ChangeNotifier {
  final ApiService apiService;
  ChangePasswordProvider({required this.apiService});

  bool _loading = false;
  String? _error;
  ChangePasswordResponse? _response;

  bool get loading => _loading;
  String? get error => _error;
  ChangePasswordResponse? get response => _response;

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _loading = true;
    _error = null;
    _response = null;
    notifyListeners();

    try {
      final res = await apiService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      _response = res;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Change password error: $e');
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clearState() {
    _loading = false;
    _error = null;
    _response = null;
    notifyListeners();
  }
}