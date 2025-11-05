// import 'package:flutter/material.dart';
// import 'base_api_service.dart';
// import '../models/response_model/home_response.dart';
// import '../models/response_model/card_success_rate_response.dart';
//
// class DashboardService extends BaseApiService {
//   Future<HomeResponse> fetchHomeData() async {
//     final response = await get('dashboard/summary');
//     return HomeResponse.fromJson(response);
//   }
//
//   Future<CardSuccessRateResponse> fetchCardSuccessRates() async {
//     try {
//       final response = await get('card-payment/success-rates');
//       return CardSuccessRateResponse.fromJson(response);
//     } catch (e) {
//       debugPrint("Card Success Rates Endpoint Error: $e");
//       // Fallback logic if needed
//       rethrow;
//     }
//   }
// }