import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fashion_store_trendora/core/error/failures.dart';
import 'package:fashion_store_trendora/features/auth/domain/entities/auth_entity.dart';
import 'package:fashion_store_trendora/features/auth/domain/repositories/auth_repository.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/login_usecase.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/register_usecase.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/get_current_user_usecase.dart';

import 'auth_usecase_test.mocks.dart';

@GenerateMocks([IAuthRepository])
void main() {
  late MockIAuthRepository mockAuthRepository;
  late LoginUsecase loginUsecase;
  late RegisterUsecase registerUsecase;
  late LogoutUsecase logoutUsecase;
  late GetCurrentUserUsecase getCurrentUserUsecase;

  setUp(() {
    mockAuthRepository = MockIAuthRepository();
    loginUsecase = LoginUsecase(authRepository: mockAuthRepository);
    registerUsecase = RegisterUsecase(authRepository: mockAuthRepository);
    logoutUsecase = LogoutUsecase(authRepository: mockAuthRepository);
    getCurrentUserUsecase =
        GetCurrentUserUsecase(authRepository: mockAuthRepository);
  });

  const tAuthEntity = AuthEntity(
    authId: 'test-id-123',
    fullName: 'Srijal Shrestha',
    email: 'srijal@example.com',
    username: 'srijal0',
    password: 'Test@1234',
  );

  // ─────────────────────────────────────────────
  // LOGIN USE CASE TESTS (3 tests)
  // ─────────────────────────────────────────────
  group('LoginUsecase', () {
    const tParams = LoginUsecaseParams(
      email: 'srijal@example.com',
      password: 'Test@1234',
    );

    test('1. should return AuthEntity when login is successful', () async {
      // Arrange
      when(mockAuthRepository.login(tParams.email, tParams.password))
          .thenAnswer((_) async => const Right(tAuthEntity));

      // Act
      final result = await loginUsecase(tParams);

      // Assert
      expect(result, const Right(tAuthEntity));
      verify(mockAuthRepository.login(tParams.email, tParams.password));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('2. should return Failure when login credentials are wrong', () async {
      // Arrange
      when(mockAuthRepository.login(tParams.email, tParams.password))
          .thenAnswer((_) async =>
              Left(ApiFailure(message: 'Invalid email or password')));

      // Act
      final result = await loginUsecase(tParams);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Invalid email or password'),
        (_) => fail('Expected failure'),
      );
    });

    test('3. should pass correct params to repository', () async {
      // Arrange
      when(mockAuthRepository.login(any, any))
          .thenAnswer((_) async => const Right(tAuthEntity));

      // Act
      await loginUsecase(tParams);

      // Assert
      verify(mockAuthRepository.login('srijal@example.com', 'Test@1234'));
    });
  });

  // ─────────────────────────────────────────────
  // REGISTER USE CASE TESTS (3 tests)
  // ─────────────────────────────────────────────
  group('RegisterUsecase', () {
    final tParams = RegisterUsecaseParams(
      fullName: 'Srijal Shrestha',
      email: 'srijal@example.com',
      username: 'srijal0',
      password: 'Test@1234',
      phoneNumber: '9800000000',
      address: 'Kathmandu',
    );

    test('4. should return true when registration is successful', () async {
      // Arrange
      when(mockAuthRepository.register(any))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await registerUsecase(tParams);

      // Assert
      expect(result, const Right(true));
      verify(mockAuthRepository.register(any));
    });

    test('5. should return Failure when registration fails', () async {
      // Arrange
      when(mockAuthRepository.register(any)).thenAnswer((_) async =>
          Left(ApiFailure(message: 'Email already exists')));

      // Act
      final result = await registerUsecase(tParams);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Email already exists'),
        (_) => fail('Expected failure'),
      );
    });

    test('6. should build AuthEntity from params and pass to repository',
        () async {
      // Arrange
      when(mockAuthRepository.register(any))
          .thenAnswer((_) async => const Right(true));

      // Act
      await registerUsecase(tParams);

      // Assert - verify register was called with an AuthEntity
      final captured =
          verify(mockAuthRepository.register(captureAny)).captured.first
              as AuthEntity;
      expect(captured.fullName, tParams.fullName);
      expect(captured.email, tParams.email);
      expect(captured.username, tParams.username);
    });
  });

  // ─────────────────────────────────────────────
  // LOGOUT USE CASE TESTS (2 tests)
  // ─────────────────────────────────────────────
  group('LogoutUsecase', () {
    test('7. should return true when logout is successful', () async {
      // Arrange
      when(mockAuthRepository.logout())
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await logoutUsecase();

      // Assert
      expect(result, const Right(true));
      verify(mockAuthRepository.logout());
    });

    test('8. should return Failure when logout fails', () async {
      // Arrange
      when(mockAuthRepository.logout()).thenAnswer(
          (_) async => Left(ApiFailure(message: 'Logout failed')));

      // Act
      final result = await logoutUsecase();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Logout failed'),
        (_) => fail('Expected failure'),
      );
    });
  });

  // ─────────────────────────────────────────────
  // GET CURRENT USER USE CASE TESTS (2 tests)
  // ─────────────────────────────────────────────
  group('GetCurrentUserUsecase', () {
    test('9. should return AuthEntity when current user exists', () async {
      // Arrange
      when(mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => const Right(tAuthEntity));

      // Act
      final result = await getCurrentUserUsecase();

      // Assert
      expect(result, const Right(tAuthEntity));
      verify(mockAuthRepository.getCurrentUser());
    });

    test('10. should return Failure when no current user found', () async {
      // Arrange
      when(mockAuthRepository.getCurrentUser()).thenAnswer(
          (_) async => Left(ApiFailure(message: 'No user found')));

      // Act
      final result = await getCurrentUserUsecase();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'No user found'),
        (_) => fail('Expected failure'),
      );
    });
  });
}