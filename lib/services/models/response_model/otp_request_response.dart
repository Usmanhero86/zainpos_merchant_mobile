class OtpRequestResponse {
  final String message;

  OtpRequestResponse({required this.message});

  factory OtpRequestResponse.fromJson(Map<String, dynamic> json) {
    return OtpRequestResponse(
      message: json['Message'] ?? json['message'] ?? '',
    );
  }
}
