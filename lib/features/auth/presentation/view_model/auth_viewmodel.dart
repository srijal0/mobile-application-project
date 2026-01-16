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
    return AuthState.initial();
  }

  /// Register new user
  Future<void> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
    required String? address,
  }) async {
    state = AuthState.loading();

    final params = RegisterUsecaseParams(
      fullName: fullName,
      username: username,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      address: address,
    );

    final result = await _registerUsecase(params);

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (_) => state = AuthState.registered(
        "Registration successful",
      ),
    );
  }

  /// Login user
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();

    final params = LoginUsecaseParams(
      email: email,
      password: password,
    );

    final result = await _loginUsecase(params);

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (entity) => state = AuthState.authenticated(entity),
    );
  }

  /// Logout user
  Future<void> logout() async {
    state = AuthState.loading();

    final result = await _logoutUsecase();

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (_) => state = const AuthState(
        status: AuthStatus.unauthenticated,
      ),
    );
  }

  /// Get current user
  Future<void> getCurrentUser() async {
    state = AuthState.loading();

    final result = await _getCurrentUserUsecase();

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (entity) => state = AuthState.authenticated(entity),
    );
  }
}
