import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../screens/account/user/user_model.dart';
import '../services/api/api_service.dart';

class LoginProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;
  String _errorMessage = '';
  String _authToken = '';
  UserModel? _currentUser;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get authToken => _authToken;
  bool get isLoggedIn => _authToken.isNotEmpty;
  UserModel? get currentUser => _currentUser;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Add this method to load token and user data
  Future<void> loadTokenAndUser() async {
    final token = await _storage.read(key: 'auth_token');
    final userData = await _storage.read(key: 'user_data');

    if (token != null) {
      _authToken = token;
    }

    if (userData != null) {
      try {
        final Map<String, dynamic> userJson = json.decode(userData);
        _currentUser = UserModel.fromJson(userJson);
      } catch (e) {
        debugPrint('Error loading user data: $e');
      }
    }

    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  Future<void> logout() async {
    _authToken = '';
    _errorMessage = '';
    _isLoading = false;
    _currentUser = null;

    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_data');

    ApiService().authToken = null;
    notifyListeners();
  }

  // Login method - updated to store user data
  Future<bool> login({required String email, required String password}) async {
    setLoading(true);
    setError('');

    final apiService = ApiService();
    try {
      final response = await apiService.login(email: email, password: password);
      _authToken = response.token;

      // Create and store user data
      _currentUser = UserModel(
        userId: response.userId,
        fullName: response.fullName,
        email: response.email,
        phoneNumber: response.phoneNumber,
        username: response.username,
        publicId: response.publicId,
        role: response.role,
        isDefaultPassword: response.isDefaultPassword,
      );

      // Save to secure storage
      await _storage.write(key: 'auth_token', value: _authToken);
      await _storage.write(key: 'user_data', value: json.encode(_currentUser!.toJson()));

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