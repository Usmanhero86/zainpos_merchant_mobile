// import '../../../services/models/response_model/dispute_list_response.dart';
//
// class DisputeModel {
//   final String reference;
//   final double amount;
//   final String terminal;
//   final String status;
//   final String resolved;
//   final String date;
//   final String transactionType;
//
//   DisputeModel({
//     required this.reference,
//     required this.amount,
//     required this.terminal,
//     required this.status,
//     required this.resolved,
//     required this.date,
//     required this.transactionType,
//   });
//
//   factory DisputeModel.fromApi(DisputeApiItem api) {
//     return DisputeModel(
//       reference: api.txnReference,
//       amount: double.tryParse(api.txnAmount) ?? 0,
//       terminal: api.terminalId,
//       status: api.status,
//       resolved: api.status == "RESOLVED" ? "RESOLVED" : "FAILED",
//       date: api.txnDate.toIso8601String().split("T").first,
//       transactionType: api.cardType,
//     );
//   }
// }
