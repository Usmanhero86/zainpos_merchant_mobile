import 'dart:convert';

class ActiveTerminalResponse {
  final int totalActiveTerminal;
  final int totalInactiveTerminal;
  final int totalTerminalRegistered;

  ActiveTerminalResponse({
    required this.totalActiveTerminal,
    required this.totalInactiveTerminal,
    required this.totalTerminalRegistered,
  });

  /// Create from a decoded JSON map
  factory ActiveTerminalResponse.fromJson(Map<String, dynamic> json) {
    return ActiveTerminalResponse(
      totalActiveTerminal: json['total_active_terminal'] ?? 0,
      totalInactiveTerminal: json['total_inactive_terminal'] ?? 0,
      totalTerminalRegistered: json['total_terminal_registered'] ?? 0,
    );
  }

  /// Convert to a JSON map
  Map<String, dynamic> toJson() => {
    'total_active_terminal': totalActiveTerminal,
    'total_inactive_terminal': totalInactiveTerminal,
    'total_terminal_registered': totalTerminalRegistered,
  };

  /// Optional convenience: parse directly from raw string
  factory ActiveTerminalResponse.fromRawJson(String str) =>
      ActiveTerminalResponse.fromJson(json.decode(str));

  /// Optional: convert back to raw string
  String toRawJson() => json.encode(toJson());
}
