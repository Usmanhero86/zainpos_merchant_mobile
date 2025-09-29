import 'package:flutter/foundation.dart';
import '../services/api/api_service.dart';
import '../services/models/response_model/bank_list_model.dart';

class BankListProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  BankListResponse? _bankList;
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  BankListResponse? get bankList => _bankList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  List<Bank> get filteredBanks {
    if (_bankList == null) return [];

    if (_searchQuery.isEmpty) {
      return _bankList!.banksSortedByName;
    }

    return _bankList!.searchBanks(_searchQuery);
  }

  List<Bank> get banksByType {
    final banks = filteredBanks;
    banks.sort((a, b) => a.type.index.compareTo(b.type.index));
    return banks;
  }

  Map<BankType, List<Bank>> get banksGroupedByType {
    final Map<BankType, List<Bank>> grouped = {};

    for (final bank in filteredBanks) {
      grouped.putIfAbsent(bank.type, () => []).add(bank);
    }

    return grouped;
  }


  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  Future<void> fetchBankList() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bankList = await _apiService.fetchBankList();

      if (kDebugMode) {
        print('Fetched ${_bankList?.data.length ?? 0} banks');
      }
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Bank list fetch error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Bank? getBankByCode(String code) {
    return _bankList?.getBankByCode(code);
  }

  Bank? getBankByName(String name) {
    return _bankList?.getBankByName(name);
  }

  void refresh() {
    _bankList = null;
    _searchQuery = '';
    fetchBankList();
  }
}