class UserModel {
  final String userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String username;
  final String publicId;
  final String role;
  final bool isDefaultPassword;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.username,
    required this.publicId,
    required this.role,
    required this.isDefaultPassword,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      username: json['username'] ?? '',
      publicId: json['public_id'] ?? '',
      role: json['role'] ?? '',
      isDefaultPassword: json['is_default_password'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'username': username,
      'public_id': publicId,
      'role': role,
      'is_default_password': isDefaultPassword,
    };
  }

  // Helper methods to extract initials and business name
  String get initials {
    if (fullName.isEmpty) return 'U';
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return fullName[0].toUpperCase();
  }

  String get businessName {
    return fullName.isNotEmpty ? '$fullName Enterprises' : 'Business Name';
  }
}