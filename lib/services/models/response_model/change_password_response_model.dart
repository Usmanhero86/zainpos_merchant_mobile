class ChangePasswordResponse {
  final String message;

  ChangePasswordResponse({required this.message});

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      message: json['Message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'Message': message,
  };
}
