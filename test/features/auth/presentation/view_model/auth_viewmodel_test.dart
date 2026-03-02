import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fashion_store_trendora/core/error/failures.dart';
import 'package:fashion_store_trendora/features/auth/domain/entities/auth_entity.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/login_usecase.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/register_usecase.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fashion_store_trendora/features/auth/presentation/state/auth_state.dart';
import 'package:fashion_store_trendora/features/auth/presentation/view_model/auth_viewmodel.dart';

import 'auth_viewmodel_test.mocks.dart';

@GenerateMocks([LoginUsecase, RegisterUsecase, LogoutUsecase, GetCurrentUserUsecase])
void main() {
  late MockLoginUsecase mockLoginUsecase;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late ProviderContainer container;

  const tAuthEntity = AuthEntity(
    authId: 'test-id-123',
    fullName: 'Srijal Shrestha',
    email: 'srijal@example.com',
    username: 'srijal0',
    password: 'Test@1234',
  );

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockRegisterUsecase = MockRegisterUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();

    container = ProviderContainer(
      overrides: [
        loginUseCaseProvider.overrideWithValue(mockLoginUsecase),
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
        getCurrentUserUsecaseProvider
            .overrideWithValue(mockGetCurrentUserUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  AuthViewModel getViewModel() =>
      container.read(authViewModelProvider.notifier);
  AuthState getState() => container.read(authViewModelProvider);

  // ─────────────────────────────────────────────
  // AUTH STATE TESTS (4 tests)
  // ─────────────────────────────────────────────
  group('AuthState', () {
    test('1. initial state should have status initial', () {
      final state = AuthState.initial();
      expect(state.status, AuthStatus.initial);
      expect(state.isInitial, true);
      expect(state.entity, isNull);
      expect(state.errorMessage, isNull);
    });

    test('2. loading state should have status loading', () {
      final state = AuthState.loading();
      expect(state.status, AuthStatus.loading);
      expect(state.isLoading, true);
    });

    test('3. authenticated state should carry the entity', () {
      final state = AuthState.authenticated(tAuthEntity);
      expect(state.status, AuthStatus.authenticated);
      expect(state.isAuthenticated, true);
      expect(state.entity, tAuthEntity);
    });

    test('4. error state should carry the error message', () {
      final state = AuthState.error('Something went wrong');
      expect(state.status, AuthStatus.error);
      expect(state.isError, true);
      expect(state.errorMessage, 'Something went wrong');
    });
  });

  // ─────────────────────────────────────────────
  // AUTH VIEWMODEL - LOGIN TESTS (2 tests)
  // ─────────────────────────────────────────────
  group('AuthViewModel - login()', () {
    test('5. should set state to authenticated on successful login', () async {
      // Arrange
      when(mockLoginUsecase(any))
          .thenAnswer((_) async => const Right(tAuthEntity));

      // Act
      await getViewModel().login(
        email: 'srijal@example.com',
        password: 'Test@1234',
      );

      // Assert
      expect(getState().status, AuthStatus.authenticated);
      expect(getState().entity, tAuthEntity);
    });

    test('6. should set state to error on failed login', () async {
      // Arrange
      when(mockLoginUsecase(any)).thenAnswer(
          (_) async => Left(ApiFailure(message: 'Invalid credentials')));

      // Act
      await getViewModel().login(
        email: 'wrong@example.com',
        password: 'wrongpass',
      );

      // Assert
      expect(getState().status, AuthStatus.error);
      expect(getState().errorMessage, 'Invalid credentials');
    });
  });

  // ─────────────────────────────────────────────
  // AUTH VIEWMODEL - REGISTER TESTS (2 tests)
  // ─────────────────────────────────────────────
  group('AuthViewModel - register()', () {
    test('7. should set state to registered on successful registration',
        () async {
      // Arrange
      when(mockRegisterUsecase(any))
          .thenAnswer((_) async => const Right(true));

      // Act
      await getViewModel().register(
        fullName: 'Srijal Shrestha',
        username: 'srijal0',
        email: 'srijal@example.com',
        password: 'Test@1234',
        confirmPassword: 'Test@1234',
        phoneNumber: '9800000000',
        address: 'Kathmandu',
      );

      // Assert
      expect(getState().status, AuthStatus.registered);
      expect(getState().successMessage, 'Registration successful');
    });

    test('8. should set state to error on failed registration', () async {
      // Arrange
      when(mockRegisterUsecase(any)).thenAnswer(
          (_) async => Left(ApiFailure(message: 'Email already exists')));

      // Act
      await getViewModel().register(
        fullName: 'Srijal Shrestha',
        username: 'srijal0',
        email: 'srijal@example.com',
        password: 'Test@1234',
        confirmPassword: 'Test@1234',
        phoneNumber: '9800000000',
        address: null,
      );

      // Assert
      expect(getState().status, AuthStatus.error);
      expect(getState().errorMessage, 'Email already exists');
    });
  });

  // ─────────────────────────────────────────────
  // AUTH VIEWMODEL - LOGOUT TESTS (1 test)
  // ─────────────────────────────────────────────
  group('AuthViewModel - logout()', () {
    test('9. should set state to unauthenticated on successful logout',
        () async {
      // Arrange
      when(mockLogoutUsecase()).thenAnswer((_) async => const Right(true));

      // Act
      await getViewModel().logout();

      // Assert
      expect(getState().status, AuthStatus.unauthenticated);
    });
  });

  // ─────────────────────────────────────────────
  // AUTH VIEWMODEL - GET CURRENT USER TEST (1 test)
  // ─────────────────────────────────────────────
  group('AuthViewModel - getCurrentUser()', () {
    test('10. should set state to authenticated with entity on success',
        () async {
      // Arrange
      when(mockGetCurrentUserUsecase())
          .thenAnswer((_) async => const Right(tAuthEntity));

      // Act
      await getViewModel().getCurrentUser();

      // Assert
      expect(getState().status, AuthStatus.authenticated);
      expect(getState().entity?.email, 'srijal@example.com');
    });
  });
}