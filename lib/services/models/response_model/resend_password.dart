class ResendOtpResponse {
  final String message;
  final bool success;

  ResendOtpResponse({required this.message, required this.success});

  factory ResendOtpResponse.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}
