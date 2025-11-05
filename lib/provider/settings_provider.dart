import 'package:flutter/foundation.dart';

class SettingsProvider with ChangeNotifier {
  bool _transfersEnabled = true;
  bool _balanceEnabled = true;
  bool _reprintEnabled = false;

  bool get transfersEnabled => _transfersEnabled;
  bool get balanceEnabled => _balanceEnabled;
  bool get reprintEnabled => _reprintEnabled;

  void updateSettings({
    bool? transfersEnabled,
    bool? balanceEnabled,
    bool? reprintEnabled,
  }) {
    _transfersEnabled = transfersEnabled ?? _transfersEnabled;
    _balanceEnabled = balanceEnabled ?? _balanceEnabled;
    _reprintEnabled = reprintEnabled ?? _reprintEnabled;
    notifyListeners();
  }

  void applySettings(Map<String, bool> settings) {
    _transfersEnabled = settings['transfers'] ?? _transfersEnabled;
    _balanceEnabled = settings['balance'] ?? _balanceEnabled;
    _reprintEnabled = settings['reprint'] ?? _reprintEnabled;
    notifyListeners();
  }
}