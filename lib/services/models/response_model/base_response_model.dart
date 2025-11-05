abstract class BaseResponse {
  final String? message;
  final String? status;

  const BaseResponse({
    this.message,
    this.status,
  });

  bool get isSuccess => status?.toLowerCase() == 'success';
  bool get isError => !isSuccess;
}

class SuccessResponse<T> extends BaseResponse {
  final T? data;

  const SuccessResponse({
    super.message,
    super.status = 'SUCCESS',
    this.data,
  });

  factory SuccessResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return SuccessResponse<T>(
      message: json['message'],
      status: json['status'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) => {
    'message': message,
    'status': status,
    'data': data != null ? toJsonT(data!) : null,
  };
}

class ErrorResponse extends BaseResponse {
  final String? error;
  final int? statusCode;
  final dynamic errorData;

  const ErrorResponse({
    super.message,
    super.status = 'ERROR',
    this.error,
    this.statusCode,
    this.errorData,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      error: json['error'],
      message: json['message'],
      status: json['status'],
      errorData: json['errorData'],
    );
  }

  Map<String, dynamic> toJson() => {
    'error': error,
    'message': message,
    'status': status,
    'errorData': errorData,
  };

  // Helper method to create error response from HTTP status code
  factory ErrorResponse.fromStatusCode(int statusCode, {String? customMessage}) {
    String message = customMessage ?? _getDefaultMessage(statusCode);
    String error = _getDefaultError(statusCode);

    return ErrorResponse(
      error: error,
      message: message,
      statusCode: statusCode,
      status: 'ERROR',
    );
  }

  static String _getDefaultError(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'BAD_REQUEST';
      case 401:
        return 'UNAUTHORIZED';
      case 403:
        return 'FORBIDDEN';
      case 404:
        return 'NOT_FOUND';
      case 500:
        return 'INTERNAL_SERVER_ERROR';
      default:
        return 'UNKNOWN_ERROR';
    }
  }

  static String _getDefaultMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'The request was invalid or cannot be served';
      case 401:
        return 'Authentication is required and has failed';
      case 403:
        return 'The request is understood but it has been refused';
      case 404:
        return 'The requested resource was not found';
      case 500:
        return 'An internal server error occurred';
      default:
        return 'An unexpected error occurred';
    }
  }
}

// API Response Handler
class ApiResponseHandler {
  static BaseResponse handleResponse(Map<String, dynamic> json) {
    final status = json['status']?.toString().toUpperCase();
    final error = json['error'];
    final message = json['message'];

    // Check if it's an error response
    if (error != null || _isErrorStatus(status)) {
      return ErrorResponse.fromJson(json);
    }

    // Default to success response
    return SuccessResponse<dynamic>(
      message: message,
      status: status ?? 'SUCCESS',
      data: json['data'] ?? json,
    );
  }

  static BaseResponse handleHttpResponse(dynamic response, int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      // Success response
      if (response is Map<String, dynamic>) {
        return handleResponse(response);
      } else {
        return SuccessResponse<dynamic>(
          message: 'Request successful',
          status: 'SUCCESS',
          data: response,
        );
      }
    } else {
      // Error response
      if (response is Map<String, dynamic>) {
        return handleResponse(response);
      } else {
        return ErrorResponse.fromStatusCode(statusCode);
      }
    }
  }

  static bool _isErrorStatus(String? status) {
    if (status == null) return false;

    final errorStatuses = [
      'BAD_REQUEST',
      'ERROR',
      'FAILED',
      'UNAUTHORIZED',
      'FORBIDDEN',
      'NOT_FOUND',
      'INTERNAL_SERVER_ERROR'
    ];

    return errorStatuses.contains(status.toUpperCase());
  }
}