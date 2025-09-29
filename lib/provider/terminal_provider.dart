import 'package:flutter/foundation.dart';
import '../services/api/api_service.dart';
import '../services/models/response_model/terminal_response.dart';

class TerminalProvider with ChangeNotifier {
  final ApiService _apiService;

  TerminalProvider({required ApiService apiService}) : _apiService = apiService;

  List<Terminals> _terminals = [];
  bool _isLoading = false;
  String? _error;

  List<Terminals> get terminals => _terminals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTerminals() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final TerminalResponse response = await _apiService.fetchTerminalsReal();
      _terminals = response.data;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Terminal fetch error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get active terminals only
  List<Terminals> get activeTerminals {
    return _terminals.where((terminal) => terminal.isActive == true).toList();
  }

  Future<void> refresh() async {
    await fetchTerminals();
  }
}