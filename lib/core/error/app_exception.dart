/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  AppException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() => 'AppException: $message (Code: $code)';
}

/// Network-related exceptions
class NetworkException extends AppException {
  NetworkException({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(
    message: message,
    code: code ?? 'NETWORK_ERROR',
    originalException: originalException,
  );
}

/// Connection timeout exception
class ConnectionTimeoutException extends NetworkException {
  ConnectionTimeoutException({
    String message = 'Connection timeout. Please check your internet.',
    dynamic originalException,
  }) : super(
    message: message,
    code: 'CONNECTION_TIMEOUT',
    originalException: originalException,
  );
}

/// Server error exception (5xx)
class ServerException extends NetworkException {
  final int? statusCode;

  ServerException({
    required String message,
    this.statusCode,
    dynamic originalException,
  }) : super(
    message: message,
    code: 'SERVER_ERROR_${statusCode ?? 500}',
    originalException: originalException,
  );
}

/// Authentication exception (401)
class AuthenticationException extends NetworkException {
  AuthenticationException({
    String message = 'Authentication failed. Please login again.',
    dynamic originalException,
  }) : super(
    message: message,
    code: 'AUTH_FAILED',
    originalException: originalException,
  );
}

/// Authorization exception (403)
class AuthorizationException extends NetworkException {
  AuthorizationException({
    String message = 'You do not have permission to access this resource.',
    dynamic originalException,
  }) : super(
    message: message,
    code: 'FORBIDDEN',
    originalException: originalException,
  );
}

/// Not found exception (404)
class NotFoundException extends NetworkException {
  NotFoundException({
    String message = 'Resource not found.',
    dynamic originalException,
  }) : super(
    message: message,
    code: 'NOT_FOUND',
    originalException: originalException,
  );
}

/// Bad request exception (400)
class BadRequestException extends NetworkException {
  BadRequestException({
    required String message,
    dynamic originalException,
  }) : super(
    message: message,
    code: 'BAD_REQUEST',
    originalException: originalException,
  );
}

/// Validation exception
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  ValidationException({
    required String message,
    this.fieldErrors,
    dynamic originalException,
  }) : super(
    message: message,
    code: 'VALIDATION_ERROR',
    originalException: originalException,
  );
}

/// Cache exception
class CacheException extends AppException {
  CacheException({
    required String message,
    dynamic originalException,
  }) : super(
    message: message,
    code: 'CACHE_ERROR',
    originalException: originalException,
  );
}

/// Unknown exception
class UnknownException extends AppException {
  UnknownException({
    String message = 'An unexpected error occurred.',
    dynamic originalException,
  }) : super(
    message: message,
    code: 'UNKNOWN_ERROR',
    originalException: originalException,
  );
}
