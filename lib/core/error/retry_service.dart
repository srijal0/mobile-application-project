import 'package:fashion_store_trendora/core/error/app_exception.dart';

/// Service for retrying failed operations with exponential backoff
class RetryService {
  final int maxRetries;
  final Duration initialDelay;
  final double backoffMultiplier;

  RetryService({
    this.maxRetries = 3,
    this.initialDelay = const Duration(milliseconds: 500),
    this.backoffMultiplier = 2.0,
  });

  /// Retries an async operation with exponential backoff
  Future<T> retry<T>(
    Future<T> Function() operation, {
    bool Function(Exception)? retryIf,
  }) async {
    Exception? lastException;
    Duration delay = initialDelay;

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        return await operation();
      } on Exception catch (e) {
        lastException = e;

        // Check if we should retry this exception
        if (retryIf != null && !retryIf(e)) {
          rethrow;
        }

        // Don't retry on certain exceptions
        if (e is AuthenticationException || e is ValidationException) {
          rethrow;
        }

        // If we've exhausted retries, throw
        if (attempt == maxRetries) {
          rethrow;
        }

        // Wait before retrying
        await Future.delayed(delay);
        delay = Duration(
          milliseconds: (delay.inMilliseconds * backoffMultiplier).toInt(),
        );
      }
    }

    throw lastException ?? UnknownException();
  }

  /// Retries with a custom retry condition
  Future<T> retryWhen<T>(
    Future<T> Function() operation,
    bool Function(Exception) retryCondition,
  ) {
    return retry(operation, retryIf: retryCondition);
  }

  /// Retries only on network errors
  Future<T> retryOnNetworkError<T>(Future<T> Function() operation) {
    return retry(
      operation,
      retryIf: (e) => e is NetworkException && e is! AuthenticationException,
    );
  }
}
