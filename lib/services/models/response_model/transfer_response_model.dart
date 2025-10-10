class TransferResponse {
  final String? transactionId;
  final String? reference;
  final String? status;
  final String? message;
  final bool? error;
  final String? code;
  final DateTime? timestamp;
  final double? amount;
  final String? currency;
  final bool isSuccess;

  // Error specific fields
  final String? errorType;
  final String? errorStatus;

  TransferResponse({
    this.transactionId,
    this.reference,
    this.status,
    this.message,
    this.error,
    this.isSuccess = true,
    this.code,
    this.timestamp,
    this.amount,
    this.currency,
    this.errorType,
    this.errorStatus,
  });

  factory TransferResponse.fromJson(Map<String, dynamic> json) {
    // Check if this is an error response based on status code or error field
    final hasError = json['error'] != null ||
        json['status'] == 'BAD_REQUEST' ||
        json['code'] != '00';

    if (hasError) {
      // This is an error response
      return TransferResponse(
        isSuccess: false,
        errorType: json['error']?.toString(),
        message: json['message']?.toString(),
        errorStatus: json['status']?.toString(),
        error: true,
        code: json['code']?.toString(),
      );
    } else {
      // This is a success response
      return TransferResponse(
        transactionId: json['transaction_id'] ?? json['transactionId'],
        reference: json['reference'] ?? json['ref'],
        status: json['status'],
        message: json['message'],
        error: json['error'],
        code: json['code'],
        timestamp: json['timestamp'] != null
            ? DateTime.tryParse(json['timestamp'])
            : DateTime.now(),
        amount: json['amount'] != null
            ? double.tryParse(json['amount'].toString())
            : null,
        currency: json['currency'] ?? 'NGN',
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'transaction_id': transactionId,
    'reference': reference,
    'status': status,
    'message': message,
    'error': error,
    'code': code,
    'timestamp': timestamp?.toIso8601String(),
    'amount': amount,
    'currency': currency,
    'errorType': errorType,
    'errorStatus': errorStatus,
  };

  bool get Success => isSuccess && (code == '00' || status == 'success');
  bool get hasError => error == true || errorType != null || !isSuccess;

  String get displayMessage {
    if (hasError) {
      return message ?? 'Transfer failed';
    }
    return message ?? 'Transfer completed successfully';
  }

  String get displayStatus {
    if (hasError) return 'Failed';
    if (status != null) return status!;
    return Success ? 'Success' : 'Pending';
  }

  // Helper methods for common error types
  bool get isInvalidPin => errorType == 'Invalid PIN' || message?.toLowerCase().contains('pin') == true;
  bool get isBadRequest => errorStatus == 'BAD_REQUEST';
  bool get isInsufficientFunds => errorType?.toLowerCase().contains('insufficient') == true ||
      message?.toLowerCase().contains('insufficient') == true;
}