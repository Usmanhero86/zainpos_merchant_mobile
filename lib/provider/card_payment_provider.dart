import 'package:flutter/foundation.dart';
import 'package:zainpos_merchant_mobile/services/api/api_service.dart';
import '../screens/banks/model/bank_model.dart';
import '../services/models/response_model/bank_list_model.dart';
import '../services/models/response_model/card_success_rate_response.dart';

class CardPaymentProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  List<BankSuccessRate> _successRates = [];
  List<BankSuccessRate> _filteredSuccessRates = [];
  String _searchQuery = '';
  final bool _useRealData = true;

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<BankSuccessRate> get successRates => _successRates;
  List<BankSuccessRate> get filteredSuccessRates => _filteredSuccessRates;
  String get searchQuery => _searchQuery;
  bool get useRealData => _useRealData;

  // Fetch card success rates from real bank data
  Future<void> fetchCardSuccessRates() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      CardSuccessRateResponse response;

      if (_useRealData) {
        // Try dedicated endpoint first, fall back to bank list
        response = await ApiService().fetchCardSuccessRatesFromEndpoint();
      } else {
        // Fallback to bank list conversion
        response = await ApiService().fetchCardSuccessRates();
      }

      _isLoading = false;

      if (response.status) {
        _successRates = response.data;
        // Sort banks alphabetically
        _successRates.sort((a, b) => a.bank.compareTo(b.bank));
        _filteredSuccessRates = _successRates;
        _errorMessage = '';
      } else {
        _errorMessage = response.message;
        _successRates = [];
        _filteredSuccessRates = [];
      }

      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load bank data: ${e.toString()}';
      _successRates = [];
      _filteredSuccessRates = [];
      notifyListeners();

      // Final fallback - use hardcoded data based on common Nigerian banks
      _loadFallbackData();
    }
  }

  // Set search query and filter banks
  void setSearchQuery(String query) {
    _searchQuery = query;

    if (query.isEmpty) {
      _filteredSuccessRates = _successRates;
    } else {
      _filteredSuccessRates = _successRates.where((bank) {
        return bank.bank.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _filteredSuccessRates = _successRates;
    notifyListeners();
  }

  // Fallback data based on common Nigerian banks
  void _loadFallbackData() {
    final commonBanks = [
      Bank(code: '044', name: 'Access Bank'),
      Bank(code: '063', name: 'Diamond Bank'),
      Bank(code: '070', name: 'Fidelity Bank'),
      Bank(code: '011', name: 'First Bank of Nigeria'),
      Bank(code: '058', name: 'Guaranty Trust Bank'),
      Bank(code: '301', name: 'Jaiz Bank'),
      Bank(code: '082', name: 'Keystone Bank'),
      Bank(code: '50211', name: 'Kuda Bank'),
      Bank(code: '050', name: 'Ecobank Nigeria'),
      Bank(code: '214', name: 'First City Monument Bank'),
      Bank(code: '032', name: 'Union Bank'),
      Bank(code: '033', name: 'United Bank for Africa'),
      Bank(code: '215', name: 'Unity Bank'),
      Bank(code: '035', name: 'Wema Bank'),
      Bank(code: '057', name: 'Zenith Bank'),
      Bank(code: '068', name: 'Standard Chartered Bank'),
      Bank(code: '232', name: 'Sterling Bank'),
      Bank(code: '100', name: 'Suntrust Bank'),
    ];

    _successRates = commonBanks.map((bank) {
      return BankSuccessRate.fromBank(bank);
    }).toList();

    // Sort alphabetically
    _successRates.sort((a, b) => a.bank.compareTo(b.bank));

    _filteredSuccessRates = _successRates;
    _errorMessage = 'Using fallback bank data';
    notifyListeners();
  }

  // Get bank statistics
  Map<String, dynamic> get statistics {
    if (_successRates.isEmpty) return {};

    final totalBanks = _successRates.length;
    final averageMcard = _successRates.map((e) => e.mcard).reduce((a, b) => a + b) ~/ totalBanks;
    final averageVerve = _successRates.map((e) => e.verve).reduce((a, b) => a + b) ~/ totalBanks;
    final averageVisa = _successRates.map((e) => e.visa).reduce((a, b) => a + b) ~/ totalBanks;

    return {
      'totalBanks': totalBanks,
      'averageMcard': averageMcard,
      'averageVerve': averageVerve,
      'averageVisa': averageVisa,
      'lastUpdated': DateTime.now(),
    };
  }

  // Get top performing banks for each card type
  List<BankSuccessRate> get topMcardBanks {
    final sorted = List<BankSuccessRate>.from(_successRates);
    sorted.sort((a, b) => b.mcard.compareTo(a.mcard));
    return sorted.take(5).toList();
  }

  List<BankSuccessRate> get topVerveBanks {
    final sorted = List<BankSuccessRate>.from(_successRates);
    sorted.sort((a, b) => b.verve.compareTo(a.verve));
    return sorted.take(5).toList();
  }

  List<BankSuccessRate> get topVisaBanks {
    final sorted = List<BankSuccessRate>.from(_successRates);
    sorted.sort((a, b) => b.visa.compareTo(a.visa));
    return sorted.take(5).toList();
  }

  // Refresh data
  Future<void> refreshData() async {
    await fetchCardSuccessRates();
  }

  // Clear error
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Reset state
  void resetState() {
    _isLoading = false;
    _errorMessage = '';
    _successRates = [];
    _filteredSuccessRates = [];
    _searchQuery = '';
    notifyListeners();
  }
}