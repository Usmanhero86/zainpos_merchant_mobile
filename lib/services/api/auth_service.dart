// import 'package:flutter/material.dart';
// import 'base_api_service.dart';
// import '../models/response_model/login_response.dart';
// import '../models/response_model/verify_otp_response.dart';
// import '../models/response_model/reset_password_response.dart';
// import '../models/response_model/resend_password.dart';
// import '../models/response_model/change_password_response_model.dart';
//
// class AuthService extends BaseApiService {
//
//   Future<LoginResponse> login({required String email, required String password}) async {
//     debugPrint('=== LOGIN REQUEST ===');
//
//     final body = {
//       'email': email,
//       'password': password,
//     };
//
//     final response = await postWithoutAuth('auth/login', body);
//
//     // Debug the actual response structure
//     debugPrint('=== LOGIN RESPONSE STRUCTURE ===');
//     response.forEach((key, value) {
//       debugPrint('$key: $value (${value.runtimeType})');
//     });
//
//     return LoginResponse.fromJson(response);
//   }
//
//   Future<void> requestOtp({required String email, required String password}) async {
//     final body = {'email': email, 'password': password};
//     await post('auth/request-otp', body);
//   }
//
//   Future<VerifyOtpResponse> verifyOtp({required String email, required String password, required String secretKey, required String otp,}) async {
//     final body = {
//       'email': email,
//       'password': password,
//       'secret_key': secretKey,
//       'otp': otp,
//     };
//
//     final response = await postWithoutAuth('auth/verify-otp', body);
//     return VerifyOtpResponse.fromJson(response);
//   }
//
//   Future<ResetPasswordResponse> resetPassword({required String email, required String otp, required String secretKey, required String newPassword, required String confirmPassword,}) async {
//     final body = {
//       'email': email,
//       'otp': otp,
//       'secret_key': secretKey,
//       'new_password': newPassword,
//       'confirm_password': confirmPassword,
//     };
//
//     final response = await post('auth/reset-password', body);
//     return ResetPasswordResponse.fromJson(response);
//   }
//
//   Future<ResendOtpResponse> resendOtp({required String email, required String secretKey,}) async {
//     final body = {
//       'email': email,
//       'secret_key': secretKey,
//     };
//
//     final response = await post('auth/resend-otp', body);
//     return ResendOtpResponse.fromJson(response);
//   }
//
//   Future<ChangePasswordResponse> changePassword({required String currentPassword, required String newPassword, required String confirmPassword,}) async {
//     final body = {
//       'current_password': currentPassword,
//       'new_password': newPassword,
//       'confirm_password': confirmPassword,
//     };
//
//     final response = await post('auth/update-password', body);
//     return ChangePasswordResponse.fromJson(response);
//   }
//
// }