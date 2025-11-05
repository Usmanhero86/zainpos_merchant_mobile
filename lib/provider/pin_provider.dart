// pin_provider.dart
import 'package:flutter/foundation.dart';
import 'package:zainpos_merchant_mobile/services/api/api_service.dart';
import '../services/models/response_model/update_pin_response.dart';

class PinProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  bool _pinUpdated = false;
  UpdatePinResponse? _lastResponse;

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get pinUpdated => _pinUpdated;
  UpdatePinResponse? get lastResponse => _lastResponse;

  // Update transaction PIN - REAL API CALL ONLY
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

      _lastResponse = response;
      _isLoading = false;

      if (response.status == 'success') {
        _pinUpdated = true;
        _errorMessage = '';
        notifyListeners();
        return response;
      } else {
        _errorMessage = response.message ?? 'Failed to update PIN';
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
}