class AuthResponse {
  final String token;
  final String userEmail;
  final String name;

  AuthResponse({
    required this.token,
    required this.userEmail,
    required this.name,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      userEmail: json['user_email'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
    'user_email': userEmail,
    'name': name,
  };
}
