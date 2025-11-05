import 'package:flutter/foundation.dart';

class SearchFilterProvider with ChangeNotifier {
  String _searchQuery = '';
  String? _selectedTrxnType;
  String? _selectedPeriod;
  String? _selectedDateFilter;
  DateTime? _selectedDate;

  // Getters
  String get searchQuery => _searchQuery;
  String? get selectedTrxnType => _selectedTrxnType;
  String? get selectedPeriod => _selectedPeriod;
  String? get selectedDateFilter => _selectedDateFilter;
  DateTime? get selectedDate => _selectedDate;

  // Setters
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedTrxnType(String? type) {
    _selectedTrxnType = type;
    notifyListeners();
  }

  void setSelectedPeriod(String? period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  void setSelectedDateFilter(String? filter) {
    _selectedDateFilter = filter;
    notifyListeners();
  }

  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  void clearAllFilters() {
    _searchQuery = '';
    _selectedTrxnType = null;
    _selectedPeriod = null;
    _selectedDateFilter = null;
    _selectedDate = null;
    notifyListeners();
  }

  bool get hasActiveFilters {
    return _searchQuery.isNotEmpty ||
        _selectedTrxnType != null ||
        _selectedPeriod != null ||
        _selectedDateFilter != null ||
        _selectedDate != null;
  }
}