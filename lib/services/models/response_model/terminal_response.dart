class TerminalResponse {
  final List<Terminals> data;

  TerminalResponse({required this.data});

  factory TerminalResponse.fromJson(Map<String, dynamic> json) {
    return TerminalResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Terminals.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((t) => t.toJson()).toList(),
  };
}

class Terminals{
  final String? authCode;
  final String? businessAddress;
  final String? businessName;
  final String? createdOn;
  final String? id;
  final String? imei;
  final bool? isActive;
  final bool? reprintEnabled;
  final bool? status;
  final String? terminalAddress;
  final String? terminalId;
  final String? terminalName;
  final bool? transferEnabled;
  final String? tsn;
  final String? updatedOn;
  final bool? viewBalanceEnabled;
  final String? virtualAccountNumber;
  final String? zainboxCode;

  Terminals({
    this.authCode,
    this.businessAddress,
    this.businessName,
    this.createdOn,
    this.id,
    this.imei,
    this.isActive,
    this.reprintEnabled,
    this.status,
    this.terminalAddress,
    this.terminalId,
    this.terminalName,
    this.transferEnabled,
    this.tsn,
    this.updatedOn,
    this.viewBalanceEnabled,
    this.virtualAccountNumber,
    this.zainboxCode,
  });

  factory Terminals.fromJson(Map<String, dynamic> json) {
    return Terminals(
      authCode: json['auth_code'] as String?,
      businessAddress: json['business_address'] as String?,
      businessName: json['business_name'] as String?,
      createdOn: json['created_on'] as String?,
      id: json['id'] as String?,
      imei: json['imei'] as String?,
      isActive: json['is_active'] as bool?,
      reprintEnabled: json['reprint_enabled'] as bool?,
      status: json['status'] as bool?,
      terminalAddress: json['terminal_address'] as String?,
      terminalId: json['terminal_id'] as String?,
      terminalName: json['terminal_name'] as String?,
      transferEnabled: json['transfer_enabled'] as bool?,
      tsn: json['tsn'] as String?,
      updatedOn: json['updated_on'] as String?,
      viewBalanceEnabled: json['view_balance_enabled'] as bool?,
      virtualAccountNumber: json['virtual_account_number'] as String?,
      zainboxCode: json['zainbox_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'auth_code': authCode,
      'business_address': businessAddress,
      'business_name': businessName,
      'created_on': createdOn,
      'id': id,
      'imei': imei,
      'is_active': isActive,
      'reprint_enabled': reprintEnabled,
      'status': status,
      'terminal_address': terminalAddress,
      'terminal_id': terminalId,
      'terminal_name': terminalName,
      'transfer_enabled': transferEnabled,
      'tsn': tsn,
      'updated_on': updatedOn,
      'view_balance_enabled': viewBalanceEnabled,
      'virtual_account_number': virtualAccountNumber,
      'zainbox_code': zainboxCode,
    };
  }
}