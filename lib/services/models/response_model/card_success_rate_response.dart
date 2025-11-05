import '../../../screens/banks/model/bank_model.dart';

class CardSuccessRateResponse {
  final bool status;
  final String message;
  final List<BankSuccessRate> data;

  CardSuccessRateResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CardSuccessRateResponse.fromJson(Map<String, dynamic> json) {
    return CardSuccessRateResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => BankSuccessRate.fromJson(item))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'CardSuccessRateResponse(status: $status, message: $message, data: $data)';
  }
}