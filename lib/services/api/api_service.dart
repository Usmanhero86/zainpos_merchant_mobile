import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zainpos_merchant_mobile/services/models/response_model/terminal_response.dart';
import '../../screens/banks/model/bank_model.dart';
import '../models/response_model/auth_response.dart';
import '../models/response_model/bank_deposit_history_response.dart';
import '../models/response_model/bank_list_model.dart';
import '../models/response_model/card_purchase_history_response.dart';
import '../models/response_model/card_success_rate_response.dart';
import '../models/response_model/change_password_response_model.dart';
import '../models/response_model/dispute_list_response.dart';
import '../models/response_model/home_response.dart';
import '../models/response_model/login_response.dart';
import '../models/response_model/payout_response_model.dart';
import '../models/response_model/resend_password.dart';
import '../models/response_model/reset_password_response.dart';
import '../models/response_model/transfer_response_model.dart';
import '../models/response_model/update_pin_response.dart';
import '../models/response_model/verify_otp_response.dart';
import '../models/response_model/wallet_balance_response.dart';

class ApiService {
  ApiService._internal();

  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;
  final String baseUrl = 'https://merchant.sandbox.zainpos.ng/api/v1';
  final String secretKey = "df32anxmxxxainwodwwsmanttss";
  String? authToken;

  Future<T> simulate<T>(T Function() body, {int ms = 800}) async {
    await Future.delayed(Duration(milliseconds: ms));
    return body();
  }

  // Login
  Future<LoginResponse> login({required String email, required String password}) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Login failed: ${response.statusCode}');
    }
  }
  //  Signup
  Future<AuthResponse> signup(String email, String password) {
    return simulate(() {
      return AuthResponse(
        token: 'new_user_token_456',
        userEmail: email,
        name: 'New Merchant',
      );
    });
  }

  // Fetch Terminals
  Future<TerminalResponse> fetchTerminalsReal() async {
    final uri = Uri.parse('$baseUrl/terminals');

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return TerminalResponse.fromJson(data);
    } else {
      throw Exception(
        'Failed to load terminals: ${response.statusCode} ${response
            .reasonPhrase}',
      );
    }
  }

  // Bank And Card Purchase History Methods
  Future<CardPurchaseHistoryResponse> fetchCardPurchaseHistory() async {
    final uri = Uri.parse('$baseUrl/transactions/card-purchase-history');
    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken'
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return CardPurchaseHistoryResponse.fromJson(data);
    } else {
      throw Exception(
          'Failed to load card purchase history: ${response.statusCode}');
    }
  }

  Future<PayoutResponseModel> fetchPayoutHistory() async {
    final uri = Uri.parse('$baseUrl/transactions/payouts-history');
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return PayoutResponseModel.fromJson(jsonData);
    } else {
      throw Exception(
        'Failed to load payout history: ${response.statusCode} ${response
            .reasonPhrase}',
      );
    }
  }

  // Fetch Bank Deposit History
  Future<BankDepositHistoryResponse> fetchBankDepositHistory({int page = 1, int limit = 25,}) async {
    final uri = Uri.parse(
      '$baseUrl/transactions/bank-deposits-history',
    );

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return BankDepositHistoryResponse.fromJson(jsonMap);
    } else {
      throw Exception(
        'Failed to load deposit history: ${response.statusCode} ${response
            .reasonPhrase}',
      );
    }
  }

  // Fetch dispute list
  Future<DisputeListResponse> getDisputes() async {
    final url = Uri.parse('$baseUrl/dispute/list');
    final response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return DisputeListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load disputes: ${response.body}');
    }
  }

  Future<HomeResponse> fetchHomeData() async {
    final uri = Uri.parse('$baseUrl/dashboard/summary');

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return HomeResponse.fromJson(data);
    } else {
      throw Exception(
        'Failed to load home data: ${response.statusCode} ${response
            .reasonPhrase}',
      );
    }
  }

  Future<BankListResponse> fetchBankList() async {
    final uri = Uri.parse('$baseUrl/banks');

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return BankListResponse.fromJson(data);
    } else {
      throw Exception(
        'Failed to load bank list: ${response.statusCode} ${response
            .reasonPhrase}',
      );
    }
  }

  Future<String?> resolveAccountName({required String bankCode, required String accountNumber,}) async {
    final uri = Uri.parse('$baseUrl/banks/account/resolve');

    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({
        "bank_code": bankCode,
        "account_number": accountNumber,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      // adjust key if your API returns a different structure
      return jsonData['account_name'] as String?;
    } else {
      throw Exception(
        'Failed to resolve account: ${response.statusCode} ${response
            .reasonPhrase}',
      );
    }
  }

  Future<ChangePasswordResponse> changePassword({required String currentPassword, required String newPassword, required String confirmPassword,}) async {
    final url = Uri.parse('$baseUrl/auth/update-password');
    final body = jsonEncode({
      'current_password': currentPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ChangePasswordResponse.fromJson(jsonResponse);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Please login again');
    } else if (response.statusCode == 400) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Invalid request');
    } else {
      throw Exception(
          'Failed to change password: ${response.statusCode} ${response.body}');
    }
  }

  /// Request OTP
  Future<void> requestOtp({required String email, required String password,}) async {
    final url = Uri.parse('$baseUrl/auth/request-otp');
    final body = jsonEncode({'email': email, 'password': password});

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: body);
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to request OTP: ${response.body}");
    }
  }

  /// Verify OTP
  Future<VerifyOtpResponse> verifyOtp({required String email, required String password, required String secretKey, required String otp,}) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final body = jsonEncode({
      'email': email,
      'password': password,
      'secret_key': secretKey,
      'otp': otp,
    });

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: body);
    if (response.statusCode == 200) {
      return VerifyOtpResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to verify OTP: ${response.body}");
    }
  }

  /// Reset Password
  Future<ResetPasswordResponse> resetPassword({required String email, required String otp, required String secretKey, required String newPassword, required String confirmPassword,}) async {
    final url = Uri.parse('$baseUrl/auth/reset-password');
    final body = jsonEncode({
      'email': email,
      'otp': otp,
      'secret_key': secretKey,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    });

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: body
    );
    if (response.statusCode == 200) {
      return ResetPasswordResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to reset password: ${response.body}");
    }
  }

  Future<ResendOtpResponse> resendOtp({required String email, required String secretKey,}) async {
    final url = Uri.parse('$baseUrl/auth/resend-otp');
    final body = jsonEncode({
      'email': email,
      'secret_key': secretKey,
    });

    final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        }, body: body
    );

    if (response.statusCode == 200) {
      return ResendOtpResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to resend OTP: ${response.body}');
    }
  }

  Future<WalletBalanceResponse?> getTerminalWalletBalance(String accountNumber) async {
    try {
      final url = Uri.parse("$baseUrl/merchant/account_balance/$accountNumber");

      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

      final response = await http.get(url, headers: headers);

      debugPrint("Wallet Balance API Response - Status: ${response.statusCode}");
      debugPrint("Wallet Balance API Response - Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check if the response has the expected structure
        if (responseData.containsKey('balance_amount')) {
          return WalletBalanceResponse(
            status: true, // Since we got a 200 response with balance data
            message: 'Balance retrieved successfully',
            data: WalletBalanceData(
              accountName: responseData['account_name'] ?? '',
              accountNumber: responseData['account_number'] ?? accountNumber,
              balanceAmount: _parseBalance(responseData['balance_amount']),
              bankName: responseData['bank_name'] ?? '',
              currency: 'NGN',
            ),
          );
        } else {
          // If the structure is different, try to parse it
          return WalletBalanceResponse.fromJson(responseData);
        }
      } else {
        debugPrint("API Error - Status: ${response.statusCode}");
        debugPrint("Error body: ${response.body}");
        return WalletBalanceResponse(
          status: false,
          message: 'Failed to load balance: ${response.statusCode}',
          data: WalletBalanceData(
            accountName: '',
            accountNumber: accountNumber,
            balanceAmount: 0.0,
            bankName: '',
            currency: 'NGN',
          ),
        );
      }
    } catch (e) {
      debugPrint("Network error: $e");
      return WalletBalanceResponse(
        status: false,
        message: 'Network error: $e',
        data: WalletBalanceData(
          accountName: '',
          accountNumber: accountNumber,
          balanceAmount: 0.0,
          bankName: '',
          currency: 'NGN',
        ),
      );
    }
  }

// Add this helper method to ApiService class
  static double _parseBalance(dynamic balance) {
    if (balance == null) return 0.0;

    if (balance is int) {
      return balance.toDouble();
    } else if (balance is double) {
      return balance;
    } else if (balance is String) {
      final cleaned = balance.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }

    return 0.0;
  }

  // Name Enquiry
  Future<String?> resolveAccountEnquiry({required String bankCode, required String accountNumber,}) async {
    try {
      final uri = Uri.parse('$baseUrl/name_enquiry').replace(
        queryParameters: {
          'bank_code': bankCode,
          'account_number': accountNumber,
        },
      );

      debugPrint("=== ACCOUNT ENQUIRY API CALL ===");
      debugPrint("URL: $uri");

      // Use GET request since we're using query parameters
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      ).timeout(const Duration(seconds: 10));

      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      // Handle empty response for 404
      if (response.statusCode == 404 && response.body.isEmpty) {
        throw Exception('Account number not found in the selected bank');
      }

      if (response.body.isEmpty) {
        throw Exception('Empty response from server');
      }

      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Check for success indicators
        if (jsonData['code'] == '00' ||
            jsonData['status'] == true ||
            jsonData['success'] == true) {

          // Try multiple possible field names
          final accountName = jsonData['data']?['accountName'] as String? ??
              jsonData['data']?['account_name'] as String? ??
              jsonData['accountName'] as String? ??
              jsonData['account_name'] as String? ??
              jsonData['data']?['name'] as String? ??
              jsonData['name'] as String?;

          if (accountName != null && accountName.isNotEmpty) {
            debugPrint("✅ SUCCESS: Account resolved: $accountName");
            return accountName.trim();
          } else {
            throw Exception('Account name not found in response data');
          }
        } else {
          final errorMessage = jsonData['description'] ??
              jsonData['message'] ??
              'Account resolution failed';
          throw Exception(errorMessage);
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on FormatException catch (e) {
      debugPrint("JSON parsing error: $e");
      throw Exception('Server returned invalid response');
    }
  }

  // fund transfer
  Future<TransferResponse> initiateFundTransfer({required String destinationAccountNumber, required String destinationAccountName, required String destinationBankCode, required String destinationBankName, required String amount, required String sourceAccountNumber, required String zainboxCode, required String narration, required String terminalId, required String pin,}) async {
    try {
      final uri = Uri.parse('$baseUrl/merchant/transfer/v2');

      debugPrint("=== FUND TRANSFER API CALL ===");
      debugPrint("Terminal ID: $terminalId");
      debugPrint("Amount: $amount");
      debugPrint("Destination: $destinationAccountNumber");
      debugPrint("Source: $sourceAccountNumber");
      debugPrint("Zainbox: $zainboxCode");

      final requestBody = {
        "destination_account_number": destinationAccountNumber,
        "destination_account_name": destinationAccountName,
        "destination_bank_code": destinationBankCode,
        "destination_bank_name": destinationBankName,
        "amount": amount,
        "source_account_number": sourceAccountNumber,
        "zainbox_code": zainboxCode,
        "narration": narration,
        "terminal_id": terminalId,
        "pin": pin,
      };

      debugPrint("Request Body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint("Fund Transfer Response - Status: ${response.statusCode}");
      debugPrint("Fund Transfer Response - Body: ${response.body}");

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Always return TransferResponse, it will handle both success and error
      final transferResponse = TransferResponse.fromJson(responseData);

      // Additional check for HTTP status codes
      if (response.statusCode != 200) {
        return TransferResponse(
          isSuccess: false,
          message: responseData['message'] ?? 'Transfer failed with status: ${response.statusCode}',
          error: true,
          errorType: 'HTTP_${response.statusCode}',
        );
      }

      return transferResponse;

    } catch (e) {
      debugPrint("Fund Transfer Error: $e");

      // Return an error response for network/exceptions
      return TransferResponse(
        isSuccess: false,
        message: 'Network error: ${e.toString().replaceAll('Exception: ', '')}',
        error: true,
        errorType: 'NetworkError',
      );
    }
  }

  // update transaction pin
  Future<UpdatePinResponse> updateTransactionPin({required String currentPin, required String newPin, required String confirmPin,}) async {
    try {
      final url = Uri.parse('$baseUrl/merchant/change_transaction_pin');

      final body = jsonEncode({
        'current_pin': currentPin,
        'new_pin': newPin,
        'confirm_pin': confirmPin,
      });

      debugPrint("Update PIN Request - URL: $url");
      debugPrint("Update PIN Request - Body: $body");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: body,
      );

      debugPrint("Update PIN Response - Status: ${response.statusCode}");
      debugPrint("Update PIN Response - Body: ${response.body}");

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return UpdatePinResponse.fromJson(responseData);
      } else if (response.statusCode == 401) {
        return UpdatePinResponse(
          status: 'failed',
          message: 'Invalid token. Please login again.',
          error: 'AUTH_ERROR',
        );
      } else if (response.statusCode == 400) {
        return UpdatePinResponse(
          status: 'failed',
          message: responseData['message'] ?? 'Invalid request',
          error: 'VALIDATION_ERROR',
        );
      } else {
        return UpdatePinResponse(
          status: 'failed',
          message: responseData['message'] ?? 'Failed to update PIN',
          error: 'SERVER_ERROR',
        );
      }
    } catch (e) {
      debugPrint("Update PIN Error: $e");
      return UpdatePinResponse(
        status: 'failed',
        message: 'Network error occurred. Please check your connection.',
        error: e.toString(),
      );
    }
  }

// Fetch Card Payment Success Rates from real bank data
  Future<CardSuccessRateResponse> fetchCardSuccessRates() async {
    try {
      // First, fetch the real bank list
      final bankListResponse = await fetchBankList();

      if (!bankListResponse.isSuccess) {
        throw Exception('Failed to load bank list: ${bankListResponse.code}');
      }

      // Convert banks to success rates
      final successRates = bankListResponse.data.map((bank) {
        return BankSuccessRate.fromBank(bank);
      }).toList();

      return CardSuccessRateResponse(
        status: true,
        message: 'Success rates loaded successfully',
        data: successRates,
      );
    } catch (e) {
      debugPrint("Card Success Rates Error: $e");
      rethrow;
    }
  }

// Alternative: Fetch from dedicated endpoint if available
  Future<CardSuccessRateResponse> fetchCardSuccessRatesFromEndpoint() async {
    try {
      final uri = Uri.parse('$baseUrl/card-payment/success-rates');

      debugPrint("=== CARD SUCCESS RATES API CALL ===");
      debugPrint("URL: $uri");

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      debugPrint("Card Success Rates Response - Status: ${response.statusCode}");
      debugPrint("Card Success Rates Response - Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return CardSuccessRateResponse.fromJson(responseData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (response.statusCode == 404) {
        // If endpoint not found, fall back to bank list data
        return await fetchCardSuccessRates();
      } else {
        throw Exception('Failed to load card success rates: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Card Success Rates Endpoint Error: $e");
      // Fall back to bank list data
      return await fetchCardSuccessRates();
    }
  }

// Mock API for development (fallback)
  Future<CardSuccessRateResponse> fetchCardSuccessRatesMock() async {
    await Future.delayed(const Duration(seconds: 2));

    return CardSuccessRateResponse(
      status: true,
      message: 'Success rates loaded successfully',
      data: [
        BankSuccessRate(
          bank: 'Access Bank',
          bankCode: '044',
          mcard: 97,
          verve: 94,
          visa: 95,
          lastUpdated: DateTime.now(),
        ),
        BankSuccessRate(
          bank: 'Diamond Bank',
          bankCode: '063',
          mcard: 97,
          verve: 97,
          visa: 97,
          lastUpdated: DateTime.now(),
        ),
        BankSuccessRate(
          bank: 'Fidelity Bank',
          bankCode: '070',
          mcard: 97,
          verve: 97,
          visa: 97,
          lastUpdated: DateTime.now(),
        ),
        BankSuccessRate(
          bank: 'First Bank of Nigeria',
          bankCode: '011',
          mcard: 97,
          verve: 50,
          visa: 97,
          lastUpdated: DateTime.now(),
        ),
        BankSuccessRate(
          bank: 'Guaranty Trust Bank',
          bankCode: '058',
          mcard: 0,
          verve: 97,
          visa: 97,
          lastUpdated: DateTime.now(),
        ),
        BankSuccessRate(
          bank: 'Jaiz Bank',
          bankCode: '301',
          mcard: 97,
          verve: 97,
          visa: 97,
          lastUpdated: DateTime.now(),
        ),
        BankSuccessRate(
          bank: 'Keystone Bank',
          bankCode: '082',
          mcard: 84,
          verve: 97,
          visa: 97,
          lastUpdated: DateTime.now(),
        ),
        BankSuccessRate(
          bank: 'Kuda Bank',
          bankCode: '50211',
          mcard: 97,
          verve: 97,
          visa: 97,
          lastUpdated: DateTime.now(),
        ),
        BankSuccessRate(
          bank: 'Ecobank Nigeria',
          bankCode: '050',
          mcard: 97,
          verve: 97,
          visa: 97,
          lastUpdated: DateTime.now(),
        ),
        BankSuccessRate(
          bank: 'First City Monument Bank',
          bankCode: '214',
          mcard: 20,
          verve: 17,
          visa: 32,
          lastUpdated: DateTime.now(),
        ),
      ],
    );
  }


}