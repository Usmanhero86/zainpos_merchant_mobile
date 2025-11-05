// import 'base_api_service.dart';
// import '../models/response_model/bank_deposit_history_response.dart';
// import '../models/response_model/card_purchase_history_response.dart';
// import '../models/response_model/payout_response_model.dart';
// import '../models/response_model/dispute_list_response.dart';
//
// class TransactionService extends BaseApiService {
//   Future<CardPurchaseHistoryResponse> fetchCardPurchaseHistory() async {
//     final response = await get('transactions/card-purchase-history');
//     return CardPurchaseHistoryResponse.fromJson(response);
//   }
//
//   Future<PayoutResponseModel> fetchPayoutHistory() async {
//     final response = await get('transactions/payouts-history');
//     return PayoutResponseModel.fromJson(response);
//   }
//
//   Future<BankDepositHistoryResponse> fetchBankDepositHistory({
//     int page = 1,
//     int limit = 25,
//   }) async {
//     final response = await get('transactions/bank-deposits-history');
//     return BankDepositHistoryResponse.fromJson(response);
//   }
//
//   Future<DisputeListResponse> getDisputes() async {
//     final response = await get('dispute/list');
//     return DisputeListResponse.fromJson(response);
//   }
// }