import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_store_trendora/core/error/retry_service.dart';
import 'package:fashion_store_trendora/core/error/app_exception.dart';

void main() {
  late RetryService retryService;

  setUp(() {
    retryService = RetryService(
      maxRetries: 2,
      initialDelay: Duration(milliseconds: 10),
      backoffMultiplier: 2.0,
    );
  });

  group('RetryService', () {
    test('should return result on first success', () async {
      // Arrange
      const expected = 'success';
      Future<String> operation() async => expected;

      // Act
      final result = await retryService.retry(operation);

      // Assert
      expect(result, equals(expected));
    });

    test('should retry on network error and eventually succeed', () async {
      // Arrange
      int callCount = 0;
      Future<String> operation() async {
        callCount++;
        if (callCount < 3) {
          throw ConnectionTimeoutException();
        }
        return 'success';
      }

      // Act
      final result = await retryService.retry(operation);

      // Assert
      expect(result, equals('success'));
      expect(callCount, equals(3));
    });

    test('should not retry on AuthenticationException', () async {
      // Arrange
      int callCount = 0;
      Future<String> operation() async {
        callCount++;
        throw AuthenticationException();
      }

      // Act & Assert
      expect(
        () => retryService.retry(operation),
        throwsA(isA<AuthenticationException>()),
      );
      expect(callCount, equals(1));
    });

    test('should not retry on ValidationException', () async {
      // Arrange
      int callCount = 0;
      Future<String> operation() async {
        callCount++;
        throw ValidationException(message: 'Invalid data');
      }

      // Act & Assert
      expect(
        () => retryService.retry(operation),
        throwsA(isA<ValidationException>()),
      );
      expect(callCount, equals(1));
    });

    test('should throw after max retries exceeded', () async {
      // Arrange
      int callCount = 0;
      Future<String> operation() async {
        callCount++;
        throw ConnectionTimeoutException();
      }

      // Act & Assert
      try {
        await retryService.retry(operation);
        fail('Should have thrown ConnectionTimeoutException');
      } on ConnectionTimeoutException {
        // Expected
        expect(callCount, equals(3)); // Should have called 3 times
      }
    });

    test('should respect custom retry condition', () async {
      // Arrange
      int callCount = 0;
      Future<String> operation() async {
        callCount++;
        throw BadRequestException(message: 'Bad request');
      }

      // Act & Assert
      expect(
        () => retryService.retryWhen(
          operation,
          (e) => e is NetworkException && e is! BadRequestException,
        ),
        throwsA(isA<BadRequestException>()),
      );
      expect(callCount, equals(1)); // Should not retry
    });

    test('should apply exponential backoff delay', () async {
      // Arrange
      int callCount = 0;
      final stopwatch = Stopwatch()..start();

      Future<String> operation() async {
        callCount++;
        if (callCount < 3) {
          throw ConnectionTimeoutException();
        }
        return 'success';
      }

      // Act
      await retryService.retry(operation);
      stopwatch.stop();

      // Assert
      expect(callCount, equals(3));
      // Should have delayed: 10ms + 20ms = at least 30ms
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(25));
    });
  });
}
