import 'dart:convert';

class LoginResponse {
  final String email;
  final int expireAt;
  final String fullName;
  final bool isDefaultPassword;
  final String phoneNumber;
  final String publicId;
  final String role;
  final String token;
  final String userId;
  final String userSecret;
  final String username;

  LoginResponse({
    required this.email,
    required this.expireAt,
    required this.fullName,
    required this.isDefaultPassword,
    required this.phoneNumber,
    required this.publicId,
    required this.role,
    required this.token,
    required this.userId,
    required this.userSecret,
    required this.username,
  });

  // Create a LoginResponse from a JSON map
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      email: json['email'] as String,
      expireAt: json['expire_at'] as int,
      fullName: json['full_name'] as String,
      isDefaultPassword: json['is_default_password'] as bool,
      phoneNumber: json['phone_number'] as String,
      publicId: json['public_id'] as String,
      role: json['role'] as String,
      token: json['token'] as String,
      userId: json['user_id'] as String,
      userSecret: json['user_secret'] as String,
      username: json['username'] as String,
    );
  }

  // Convert this object back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'expire_at': expireAt,
      'full_name': fullName,
      'is_default_password': isDefaultPassword,
      'phone_number': phoneNumber,
      'public_id': publicId,
      'role': role,
      'token': token,
      'user_id': userId,
      'user_secret': userSecret,
      'username': username,
    };
  }

  // Helper to create from a raw JSON string
  factory LoginResponse.fromRawJson(String str) =>
      LoginResponse.fromJson(json.decode(str));

  // Helper to convert to a raw JSON string
  String toRawJson() => json.encode(toJson());
}
