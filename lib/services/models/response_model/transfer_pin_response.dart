import 'base_response_model.dart';

class TransferPinResponse extends BaseResponse {
  final String? error;
  final bool? isPinValid;
  final int? remainingAttempts;
  final bool? isAccountLocked;
  final DateTime? lockedUntil;

  const TransferPinResponse({
    super.message,
    super.status,
    this.error,
    this.isPinValid,
    this.remainingAttempts,
    this.isAccountLocked,
    this.lockedUntil,
  });

  factory TransferPinResponse.success({
    String? message = 'PIN verification successful',
    bool? isPinValid = true,
    int? remainingAttempts,
  }) {
    return TransferPinResponse(
      status: 'SUCCESS',
      message: message,
      isPinValid: isPinValid,
      remainingAttempts: remainingAttempts,
    );
  }

  factory TransferPinResponse.error({required String error, required String message, int? remainingAttempts, bool? isAccountLocked, DateTime? lockedUntil,}) {
    return TransferPinResponse(
      status: 'BAD_REQUEST',
      error: error,
      message: message,
      isPinValid: false,
      remainingAttempts: remainingAttempts,
      isAccountLocked: isAccountLocked,
      lockedUntil: lockedUntil,
    );
  }

  factory TransferPinResponse.fromJson(Map<String, dynamic> json) {
    return TransferPinResponse(
      error: json['error'],
      message: json['message'],
      status: json['status'],
      isPinValid: json['isPinValid'],
      remainingAttempts: json['remainingAttempts'],
      isAccountLocked: json['isAccountLocked'],
      lockedUntil: json['lockedUntil'] != null
          ? DateTime.tryParse(json['lockedUntil'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'error': error,
    'message': message,
    'status': status,
    'isPinValid': isPinValid,
    'remainingAttempts': remainingAttempts,
    'isAccountLocked': isAccountLocked,
    'lockedUntil': lockedUntil?.toIso8601String(),
  };

  // Helper methods
  bool get shouldShowRemainingAttempts => remainingAttempts != null && remainingAttempts! > 0;
  bool get shouldLockAccount => isAccountLocked == true;

  String get displayMessage {
    if (isSuccess) {
      return message ?? 'Transaction completed successfully';
    } else {
      if (isAccountLocked == true && lockedUntil != null) {
        return 'Account locked. Try again after ${_formatLockTime(lockedUntil!)}';
      }
      return message ?? 'An error occurred';
    }
  }

  String _formatLockTime(DateTime lockedUntil) {
    final now = DateTime.now();
    final difference = lockedUntil.difference(now);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours';
    } else {
      return '${difference.inDays} days';
    }
  }
}