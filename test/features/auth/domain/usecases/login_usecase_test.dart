import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:fashion_store_trendora/core/error/failures.dart';
import 'package:fashion_store_trendora/features/auth/domain/entities/auth_entity.dart';
import 'package:fashion_store_trendora/features/auth/domain/repositories/auth_repository.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/login_usecase.dart';

@GenerateMocks([IAuthRepository])
void main() {
  late LoginUsecase loginUsecase;
  late MockIAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockIAuthRepository();
    loginUsecase = LoginUsecase(authRepository: mockAuthRepository);
  });

  group('LoginUsecase', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    final testAuthEntity = const AuthEntity(
      authId: 'user_123',
      fullName: 'Test User',
      email: testEmail,
      username: 'testuser',
    );

    test('should return AuthEntity when login is successful', () async {
      // Arrange
      when(mockAuthRepository.login(testEmail, testPassword))
          .thenAnswer((_) async => Right(testAuthEntity));

      // Act
      final result = await loginUsecase(
        LoginUsecaseParams(email: testEmail, password: testPassword),
      );

      // Assert
      expect(result, Right(testAuthEntity));
      verify(mockAuthRepository.login(testEmail, testPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure when login fails', () async {
      // Arrange
      final testFailure = ApiFailure(message: 'Invalid credentials');
      when(mockAuthRepository.login(testEmail, testPassword))
          .thenAnswer((_) async => Left(testFailure));

      // Act
      final result = await loginUsecase(
        LoginUsecaseParams(email: testEmail, password: testPassword),
      );

      // Assert
      expect(result, Left(testFailure));
      verify(mockAuthRepository.login(testEmail, testPassword)).called(1);
    });

    test('should return Failure on network error', () async {
      // Arrange
      final testFailure = ApiFailure(message: 'Unable to connect');
      when(mockAuthRepository.login(testEmail, testPassword))
          .thenAnswer((_) async => Left(testFailure));

      // Act
      final result = await loginUsecase(
        LoginUsecaseParams(email: testEmail, password: testPassword),
      );

      // Assert
      expect(result, Left(testFailure));
    });

    test('should pass correct parameters to repository', () async {
      // Arrange
      when(mockAuthRepository.login(testEmail, testPassword))
          .thenAnswer((_) async => Right(testAuthEntity));

      // Act
      await loginUsecase(
        LoginUsecaseParams(email: testEmail, password: testPassword),
      );

      // Assert
      verify(mockAuthRepository.login(testEmail, testPassword)).called(1);
    });
  });
}
