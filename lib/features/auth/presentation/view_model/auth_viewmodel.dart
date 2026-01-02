// lib/features/auth/presentation/view_model/auth_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/login_usecase.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/register_usecase.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fashion_store_trendora/features/auth/presentation/state/auth_state.dart';

/// Riverpod provider for AuthViewModel
final authViewModelProvider =
    NotifierProvider<AuthViewModel, AuthState>(() => AuthViewModel());

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final GetCurrentUserUsecase _getCurrentUserUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUseCaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    return const AuthState();
  }

  /// Register new user
  Future<void> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = RegisterUsecaseParams(
      fullName: fullName,
      email: email,
      username: username,
      password: password,
    );

    final result = await _registerUsecase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        if (success) {
          state = state.copyWith(
            status: AuthStatus.registering,
            successMessage: "Registration successful",
          );
        } else {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: "Registration failed",
          );
        }
      },
    );
  }

  /// Login user
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = LoginUsecaseParams(email: email, password: password);
    final result = await _loginUsecase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (entity) => state = state.copyWith(
        status: AuthStatus.authenticated,
        entity: entity,
        successMessage: "Login successful",
      ),
    );
  }

  /// Logout user
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _logoutUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        if (success) {
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            successMessage: "Logged out successfully",
            entity: null,
          );
        } else {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: "Logout failed",
          );
        }
      },
    );
  }

  /// Get current user
  Future<void> getCurrentUser() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _getCurrentUserUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (entity) => state = state.copyWith(
        status: AuthStatus.authenticated,
        entity: entity,
      ),
    );
  }
}
