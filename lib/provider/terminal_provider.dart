import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/api/api_service.dart';
import '../services/models/response_model/terminal_response.dart';

class TerminalProvider with ChangeNotifier {
  final ApiService _apiService;

  TerminalProvider({required ApiService apiService}) : _apiService = apiService;

  List<Terminals> _terminals = [];
  List<Terminals> _filteredTerminals = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  TerminalFilter _currentFilter = TerminalFilter.all;

  List<Terminals> get terminals => _terminals;
  List<Terminals> get filteredTerminals => _filteredTerminals;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  TerminalFilter get currentFilter => _currentFilter;

  Future<void> fetchTerminals() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final TerminalResponse response = await _apiService.fetchTerminalsReal();
      _terminals = response.data;
      _filteredTerminals = _terminals; // Initialize filtered list
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

  // Search terminals by query and filter
  void searchTerminals(String query, {TerminalFilter filter = TerminalFilter.all}) {
    _searchQuery = query;
    _currentFilter = filter;

    if (query.isEmpty && filter == TerminalFilter.all) {
      _filteredTerminals = _terminals;
    } else {
      _filteredTerminals = _terminals.where((terminal) {
        final matchesSearch = query.isEmpty ? true : _matchesSearch(terminal, query);
        final matchesFilter = _matchesFilter(terminal, filter);
        return matchesSearch && matchesFilter;
      }).toList();
    }

    notifyListeners();
  }

  bool _matchesSearch(Terminals terminal, String query) {
    final lowercaseQuery = query.toLowerCase();

    // Search in terminal name
    if (terminal.terminalName?.toLowerCase().contains(lowercaseQuery) == true) {
      return true;
    }

    // Search in terminal ID
    if (terminal.terminalId?.toLowerCase().contains(lowercaseQuery) == true) {
      return true;
    }

    // Search in virtual account number
    if (terminal.virtualAccountNumber?.toLowerCase().contains(lowercaseQuery) == true) {
      return true;
    }

    // Search in business name
    if (terminal.businessName?.toLowerCase().contains(lowercaseQuery) == true) {
      return true;
    }

    // Search in terminal address
    if (terminal.terminalAddress?.toLowerCase().contains(lowercaseQuery) == true) {
      return true;
    }

    // Search in status (convert bool to string)
    final statusText = _getStatusText(terminal);
    if (statusText.toLowerCase().contains(lowercaseQuery)) {
      return true;
    }

    // Search in TSN
    if (terminal.tsn?.toLowerCase().contains(lowercaseQuery) == true) {
      return true;
    }

    // Search in IMEI
    if (terminal.imei?.toLowerCase().contains(lowercaseQuery) == true) {
      return true;
    }

    // Search in Zainbox code
    if (terminal.zainboxCode?.toLowerCase().contains(lowercaseQuery) == true) {
      return true;
    }

    return false;
  }

  bool _matchesFilter(Terminals terminal, TerminalFilter filter) {
    switch (filter) {
      case TerminalFilter.all:
        return true;
      case TerminalFilter.active:
        return terminal.isActive == true;
      case TerminalFilter.inactive:
        return terminal.isActive == false;
      case TerminalFilter.transferEnabled:
        return terminal.transferEnabled == true;
      case TerminalFilter.balanceEnabled:
        return terminal.viewBalanceEnabled == true;
      case TerminalFilter.reprintEnabled:
        return terminal.reprintEnabled == true;
    }
  }

  String _getStatusText(Terminals terminal) {
    if (terminal.isActive == true) return 'active';
    if (terminal.isActive == false) return 'inactive';
    if (terminal.status == true) return 'online';
    if (terminal.status == false) return 'offline';
    return 'unknown';
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _currentFilter = TerminalFilter.all;
    _filteredTerminals = _terminals;
    notifyListeners();
  }

  // Apply filter only
  void applyFilter(TerminalFilter filter) {
    _currentFilter = filter;
    searchTerminals(_searchQuery, filter: filter);
  }

  // Get active terminals only
  List<Terminals> get activeTerminals {
    return _terminals.where((terminal) => terminal.isActive == true).toList();
  }

  // Get terminals with transfer enabled
  List<Terminals> get transferEnabledTerminals {
    return _terminals.where((terminal) => terminal.transferEnabled == true).toList();
  }

  // Get terminals with view balance enabled
  List<Terminals> get balanceEnabledTerminals {
    return _terminals.where((terminal) => terminal.viewBalanceEnabled == true).toList();
  }

  // Get terminals with reprint enabled
  List<Terminals> get reprintEnabledTerminals {
    return _terminals.where((terminal) => terminal.reprintEnabled == true).toList();
  }

  // Get terminal statistics
  Map<String, dynamic> get statistics {
    final total = _terminals.length;
    final active = _terminals.where((t) => t.isActive == true).length;
    final transferEnabled = _terminals.where((t) => t.transferEnabled == true).length;
    final balanceEnabled = _terminals.where((t) => t.viewBalanceEnabled == true).length;
    final reprintEnabled = _terminals.where((t) => t.reprintEnabled == true).length;

    return {
      'total': total,
      'active': active,
      'inactive': total - active,
      'transferEnabled': transferEnabled,
      'balanceEnabled': balanceEnabled,
      'reprintEnabled': reprintEnabled,
    };
  }

  Future<void> refresh() async {
    await fetchTerminals();
  }
}

enum TerminalFilter {
  all,
  active,
  inactive,
  transferEnabled,
  balanceEnabled,
  reprintEnabled,
}

extension TerminalFilterExtension on TerminalFilter {
  String get displayName {
    switch (this) {
      case TerminalFilter.all:
        return 'All Terminals';
      case TerminalFilter.active:
        return 'Active';
      case TerminalFilter.inactive:
        return 'Inactive';
      case TerminalFilter.transferEnabled:
        return 'Transfer Enabled';
      case TerminalFilter.balanceEnabled:
        return 'Balance View Enabled';
      case TerminalFilter.reprintEnabled:
        return 'Reprint Enabled';
    }
  }

  IconData get icon {
    switch (this) {
      case TerminalFilter.all:
        return Icons.all_inclusive;
      case TerminalFilter.active:
        return Icons.check_circle;
      case TerminalFilter.inactive:
        return Icons.cancel;
      case TerminalFilter.transferEnabled:
        return Icons.swap_horiz;
      case TerminalFilter.balanceEnabled:
        return Icons.account_balance_wallet;
      case TerminalFilter.reprintEnabled:
        return Icons.print;
    }
  }

  String get description {
    switch (this) {
      case TerminalFilter.all:
        return 'Show all terminals';
      case TerminalFilter.active:
        return 'Show only active terminals';
      case TerminalFilter.inactive:
        return 'Show only inactive terminals';
      case TerminalFilter.transferEnabled:
        return 'Show terminals with transfer enabled';
      case TerminalFilter.balanceEnabled:
        return 'Show terminals with balance view enabled';
      case TerminalFilter.reprintEnabled:
        return 'Show terminals with reprint enabled';
    }
  }
}