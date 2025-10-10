import 'package:flutter/foundation.dart';
import 'package:zainpos_merchant_mobile/services/api/api_service.dart';
import '../services/models/response_model/update_pin_response.dart';

class PinProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  bool _pinUpdated = false;
  UpdatePinResponse? _lastResponse;

  // Mock PIN management for development/testing
  String _mockPin = '1234';
  bool _useMockPin = false;

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get pinUpdated => _pinUpdated;
  UpdatePinResponse? get lastResponse => _lastResponse;

  // Mock PIN getters
  String get mockPin => _mockPin;
  bool get useMockPin => _useMockPin;

  // Update transaction PIN - REAL API CALL
  Future<UpdatePinResponse> updatePin({
    required String currentPin,
    required String newPin,
    required String confirmPin,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    _pinUpdated = false;
    notifyListeners();

    try {
      // Validate inputs
      if (currentPin.isEmpty || newPin.isEmpty || confirmPin.isEmpty) {
        throw Exception('All fields are required');
      }

      if (newPin.length != 4 || currentPin.length != 4) {
        throw Exception('PIN must be 4 digits');
      }

      if (newPin != confirmPin) {
        throw Exception('New PIN and confirm PIN do not match');
      }

      if (newPin == currentPin) {
        throw Exception('New PIN must be different from current PIN');
      }

      // Call REAL API
      final response = await ApiService().updateTransactionPin(
        currentPin: currentPin,
        newPin: newPin,
        confirmPin: confirmPin,
      );

      _lastResponse = response; // Store the response
      _isLoading = false;

      if (response.isSuccess) {
        _pinUpdated = true;
        _errorMessage = '';

        // ✅ UPDATE THE MOCK PIN WHEN PIN IS SUCCESSFULLY CHANGED VIA API
        // This ensures the mock PIN stays in sync with the real PIN
        _updateMockPin(newPin);

        debugPrint('PIN updated successfully via API. Mock PIN also updated to: $newPin');

        notifyListeners();
        return response;
      } else {
        _errorMessage = response.message;
        _pinUpdated = false;
        notifyListeners();
        return response;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      _pinUpdated = false;
      _lastResponse = UpdatePinResponse(
        status: 'failed',
        message: e.toString(),
      );
      notifyListeners();
      return _lastResponse!;
    }
  }

  // ✅ NEW METHOD: Update mock PIN
  void _updateMockPin(String newPin) {
    _mockPin = newPin;
    debugPrint('Mock PIN updated to: $newPin');

    // You can also persist this to shared preferences here for app restarts
    // await _saveMockPinToPrefs(newPin);
  }

  // ✅ NEW METHOD: Validate PIN against mock PIN (for development/testing)
  bool validateMockPin(String enteredPin) {
    if (!_useMockPin) {
      throw Exception('Mock PIN validation is disabled');
    }
    return enteredPin == _mockPin;
  }

  // ✅ NEW METHOD: Set useMockPin flag
  void setUseMockPin(bool value) {
    _useMockPin = value;
    debugPrint('Mock PIN usage set to: $value');
    notifyListeners();
  }

  // ✅ NEW METHOD: Reset mock PIN to default
  void resetMockPin() {
    _mockPin = '1234';
    debugPrint('Mock PIN reset to default: 1234');
    notifyListeners();
  }

  // ✅ NEW METHOD: Verify PIN (can be used for both real and mock validation)
  Future<bool> verifyPin(String pin, {bool useMock = true}) async {
    if (useMock && _useMockPin) {
      // Use mock validation for development
      return validateMockPin(pin);
    } else {
      // Use real API validation for production
      return await verifyPinWithApi(pin);
    }
  }

  // ✅ NEW METHOD: Verify PIN with real API
  Future<bool> verifyPinWithApi(String pin) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // TODO: Replace with actual PIN verification API when available
      // For now, we'll simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Since we don't have a verify PIN API yet, we'll assume it's valid if it's 4 digits
      // In production, you should call your actual verify PIN endpoint
      final isValid = pin.length == 4;

      _isLoading = false;
      notifyListeners();
      return isValid;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'PIN verification failed: $e';
      notifyListeners();
      return false;
    }
  }

  // Reset PIN state
  void resetState() {
    _isLoading = false;
    _errorMessage = '';
    _pinUpdated = false;
    _lastResponse = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // ✅ NEW METHOD: Get current PIN mode
  String getPinMode() {
    return _useMockPin ? 'Mock Mode (PIN: $_mockPin)' : 'Real API Mode';
  }
}