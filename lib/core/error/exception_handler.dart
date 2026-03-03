import 'package:dio/dio.dart';
import 'package:fashion_store_trendora/core/error/app_exception.dart';

/// Converts Dio exceptions to app-specific exceptions
class ExceptionHandler {
  static AppException handleException(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    } else if (error is AppException) {
      return error;
    } else {
      return UnknownException(originalException: error);
    }
  }

  static AppException _handleDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ConnectionTimeoutException(
          originalException: dioException,
        );
      case DioExceptionType.receiveTimeout:
        return ConnectionTimeoutException(
          message: 'Server response timeout. Please try again.',
          originalException: dioException,
        );
      case DioExceptionType.sendTimeout:
        return ConnectionTimeoutException(
          message: 'Request timeout. Please check your connection.',
          originalException: dioException,
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(
          dioException.response?.statusCode,
          dioException.response?.data,
          dioException,
        );
      case DioExceptionType.badCertificate:
        return NetworkException(
          message: 'Certificate validation failed.',
          code: 'BAD_CERTIFICATE',
          originalException: dioException,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'Unable to connect. Please check your internet.',
          code: 'CONNECTION_ERROR',
          originalException: dioException,
        );
      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Request was cancelled.',
          code: 'REQUEST_CANCELLED',
          originalException: dioException,
        );
      case DioExceptionType.unknown:
        return UnknownException(originalException: dioException);
    }
  }

  static AppException _handleBadResponse(
    int? statusCode,
    dynamic responseData,
    DioException originalException,
  ) {
    final message = _extractErrorMessage(responseData);

    switch (statusCode) {
      case 400:
        return BadRequestException(
          message: message ?? 'Invalid request.',
          originalException: originalException,
        );
      case 401:
        return AuthenticationException(
          message: message ?? 'Authentication failed.',
          originalException: originalException,
        );
      case 403:
        return AuthorizationException(
          message: message ?? 'Access denied.',
          originalException: originalException,
        );
      case 404:
        return NotFoundException(
          message: message ?? 'Resource not found.',
          originalException: originalException,
        );
      case 422:
        return ValidationException(
          message: message ?? 'Validation failed.',
          originalException: originalException,
        );
      default:
        if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message: message ?? 'Server error occurred.',
            statusCode: statusCode,
            originalException: originalException,
          );
        }
        return NetworkException(
          message: message ?? 'An error occurred.',
          code: 'HTTP_ERROR_$statusCode',
          originalException: originalException,
        );
    }
  }

  /// Extracts error message from response data
  static String? _extractErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      // Try common error message fields
      return responseData['message'] ??
          responseData['error'] ??
          responseData['error_message'] ??
          responseData['msg'];
    }
    return null;
  }
}
