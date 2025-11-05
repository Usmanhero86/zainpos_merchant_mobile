import 'package:flutter/material.dart';

import 'base_response_model.dart';

class TransferResponse {
  final bool isSuccess;
  final bool success;
  final String? message;
  final String? reference;
  final String? transactionId;
  final bool error;
  final String? errorType;
  final String? code;
  final String? description;

  TransferResponse({
    required this.isSuccess,
    required this.success,
    this.message,
    this.reference,
    this.transactionId,
    required this.error,
    this.errorType,
    this.code,
    this.description,
  });

  factory TransferResponse.fromJson(Map<String, dynamic> json) {
    // More robust success detection
    final String? description = json['description']?.toString();
    final String? code = json['code']?.toString();
    final String? status = json['status']?.toString();

    // Check data object
    final Map<String, dynamic>? data = json['data'] is Map ? json['data'] as Map<String, dynamic> : null;
    final String? dataStatus = data?['status']?.toString();

    // Multiple success indicators
    final bool hasSuccessDescription = description?.toLowerCase().contains('success') == true;
    final bool hasSuccessCode = code == '200 OK' || status == '200 OK';
    final bool hasSuccessData = dataStatus == 'success';
    final bool hasNoError = json['error'] == null || json['error'] == false;

    // Final success determination
    final bool isSuccess = (hasSuccessDescription || hasSuccessCode || hasSuccessData) && hasNoError;

    // Extract reference
    final String? reference = data?['txnRef']?.toString() ??
        data?['paymentRef']?.toString() ??
        json['reference']?.toString();

    return TransferResponse(
      isSuccess: isSuccess,
      success: isSuccess,
      message: description,
      reference: reference,
      transactionId: data?['txnRef']?.toString(),
      error: !isSuccess,
      errorType: isSuccess ? null : json['errorType']?.toString(),
      code: code,
      description: description,
    );
  }

  factory TransferResponse.fromError(ErrorResponse error) {
    return TransferResponse(
      isSuccess: false,
      success: false,
      message: error.message,
      error: true,
      errorType: error.error,
      code: error.statusCode?.toString(),
    );
  }

  // Helper methods for common error types
  bool get isInvalidPin =>
      errorType?.toLowerCase().contains('pin') == true ||
          message?.toLowerCase().contains('pin') == true ||
          description?.toLowerCase().contains('pin') == true ||
          code?.toLowerCase().contains('pin') == true;

  bool get isInsufficientFunds =>
      errorType?.toLowerCase().contains('balance') == true ||
          errorType?.toLowerCase().contains('insufficient') == true ||
          message?.toLowerCase().contains('insufficient') == true ||
          description?.toLowerCase().contains('insufficient') == true ||
          message?.toLowerCase().contains('balance') == true ||
          code == 'INSUFFICIENT_FUNDS';

  bool get hasError => error || !isSuccess;

  String get displayMessage {
    if (isSuccess) {
      return message ?? 'Transfer completed successfully';
    } else {
      if (isInvalidPin) {
        return 'Invalid PIN. Please check and try again.';
      } else if (isInsufficientFunds) {
        return 'Insufficient funds to complete this transfer.';
      }
      return message ?? description ?? 'Transfer failed. Please try again.';
    }
  }

  Map<String, dynamic> toJson() => {
    'isSuccess': isSuccess,
    'Success': success,
    'message': message,
    'reference': reference,
    'transactionId': transactionId,
    'error': error,
    'errorType': errorType,
    'code': code,
    'description': description,
  };
}