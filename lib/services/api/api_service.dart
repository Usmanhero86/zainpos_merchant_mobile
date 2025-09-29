import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zainpos_merchant_mobile/services/models/response_model/terminal_response.dart';
import '../models/response_model/auth_response.dart';
import '../models/response_model/bank_deposit_history_response.dart';
import '../models/response_model/bank_list_model.dart';
import '../models/response_model/card_purchase_history_response.dart';
import '../models/response_model/change_password_response_model.dart';
import '../models/response_model/dispute_list_response.dart';
import '../models/response_model/home_response.dart';
import '../models/response_model/login_response.dart';
import '../models/response_model/payout_response_model.dart';

class ApiService {
  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  final String baseUrl = 'https://merchant.sandbox.zainpos.ng/api/v1';
  String? authToken ;

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
        'Failed to load terminals: ${response.statusCode} ${response.reasonPhrase}',
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
        'Failed to load payout history: ${response.statusCode} ${response.reasonPhrase}',
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
  Future<DisputeListResponse> fetchDisputeList() async {
    final uri = Uri.parse('$baseUrl/dispute/list');

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      // Parse the JSON into our model
      return DisputeListResponse.fromRawJson(response.body);
    } else {
      throw Exception(
        'Failed to load dispute list: ${response.statusCode} ${response.reasonPhrase}',
      );
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
        'Failed to load home data: ${response.statusCode} ${response.reasonPhrase}',
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
        'Failed to load bank list: ${response.statusCode} ${response.reasonPhrase}',
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
        'Failed to resolve account: ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }

  Future<ChangePasswordResponse> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
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
      throw Exception('Failed to change password: ${response.statusCode} ${response.body}');
    }
  }
}

