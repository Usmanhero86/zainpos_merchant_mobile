class UpdatePinResponse {
  final String status;
  final String message;
  final String? error;
  final String? reference;
  final DateTime? timestamp;
  final bool success;

  UpdatePinResponse({
    required this.status,
    required this.message,
    this.error,
    this.reference,
    this.timestamp,
  }) : success = status == 'success';

  factory UpdatePinResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePinResponse(
      status: json['status'] ?? 'failed',
      message: json['message'] ?? '',
      error: json['error'],
      reference: json['reference'],
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (error != null) 'error': error,
      if (reference != null) 'reference': reference,
      if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
    };
  }

  bool get isSuccess => status == 'success';
  bool get isFailed => status == 'failed';

  @override
  String toString() {
    return 'UpdatePinResponse(status: $status, message: $message, error: $error, success: $success)';
  }
}