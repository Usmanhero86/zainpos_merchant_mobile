import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api/api_service.dart';

class LoginProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;
  String _errorMessage = '';
  String _authToken = '';


  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get authToken => _authToken;
  bool get isLoggedIn => _authToken.isNotEmpty;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  Future<void> loadToken() async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      _authToken = token;
      notifyListeners();
    }
  }

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  Future <void> logout() async{
    _authToken = '';
    _errorMessage = '';
    _isLoading = false;

    await _storage.delete(key: 'auth_token');

    ApiService().authToken = null;

    notifyListeners();
  }

  // Login method
  Future<bool> login({required String email, required String password,}) async {
    setLoading(true);
    setError('');

    final apiService = ApiService();
    try {
      final response = await apiService.login(email: email, password: password);
      _authToken = response.token;
      await _storage.write(key: 'auth_token', value: _authToken);
      apiService.authToken = _authToken;
      setLoading(false);
      return true;
    } catch (e) {
      setError(e.toString());
      setLoading(false);
      return false;
    }
  }

  // Password reset method
  Future<bool> resetPassword(String email) async {
    setLoading(true);
    setError('');

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (email.isEmpty || !email.contains('@')) {
        setError('Please enter a valid email address');
        setLoading(false);
        return false;
      }

      setLoading(false);
      return true;

    } catch (e) {
      setError('Failed to reset password: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }
}