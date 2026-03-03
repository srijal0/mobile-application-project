import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_store_trendora/core/error/exception_handler.dart';
import 'package:fashion_store_trendora/core/error/app_exception.dart';
import 'package:dio/dio.dart';

void main() {
  group('ExceptionHandler', () {
    test('should convert ConnectionTimeout DioException correctly', () {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      // Act
      final appException = ExceptionHandler.handleException(dioException);

      // Assert
      expect(appException, isA<ConnectionTimeoutException>());
      expect(appException.code, equals('CONNECTION_TIMEOUT'));
      expect(appException.message, contains('timeout'));
    });

    test('should convert 401 status code to AuthenticationException', () {
      // Arrange
      final response = Response(
        statusCode: 401,
        data: {'message': 'Unauthorized'},
        requestOptions: RequestOptions(path: '/test'),
      );
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: response,
        type: DioExceptionType.badResponse,
      );

      // Act
      final appException = ExceptionHandler.handleException(dioException);

      // Assert
      expect(appException, isA<AuthenticationException>());
      expect(appException.code, equals('AUTH_FAILED'));
    });

    test('should convert 404 status code to NotFoundException', () {
      // Arrange
      final response = Response(
        statusCode: 404,
        data: {'message': 'Not found'},
        requestOptions: RequestOptions(path: '/test'),
      );
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: response,
        type: DioExceptionType.badResponse,
      );

      // Act
      final appException = ExceptionHandler.handleException(dioException);

      // Assert
      expect(appException, isA<NotFoundException>());
      expect(appException.code, equals('NOT_FOUND'));
    });

    test('should convert 500 status code to ServerException', () {
      // Arrange
      final response = Response(
        statusCode: 500,
        data: {'message': 'Internal server error'},
        requestOptions: RequestOptions(path: '/test'),
      );
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: response,
        type: DioExceptionType.badResponse,
      );

      // Act
      final appException = ExceptionHandler.handleException(dioException);

      // Assert
      expect(appException, isA<ServerException>());
      expect(appException.code, equals('SERVER_ERROR_500'));
    });

    test('should extract error message from response data', () {
      // Arrange
      final response = Response(
        statusCode: 400,
        data: {'message': 'Invalid email format'},
        requestOptions: RequestOptions(path: '/test'),
      );
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: response,
        type: DioExceptionType.badResponse,
      );

      // Act
      final appException = ExceptionHandler.handleException(dioException);

      // Assert
      expect(appException.message, equals('Invalid email format'));
    });

    test('should handle AppException pass-through', () {
      // Arrange
      final appException = UnknownException(message: 'Test error');

      // Act
      final result = ExceptionHandler.handleException(appException);

      // Assert
      expect(result, equals(appException));
    });

    test('should wrap unknown exception in UnknownException', () {
      // Arrange & Act
      final result = ExceptionHandler.handleException(Exception('test'));

      // Assert
      expect(result, isA<UnknownException>());
    });
  });
}
