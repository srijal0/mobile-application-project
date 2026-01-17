import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/login_usecase.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/register_usecase.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fashion_store_trendora/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fashion_store_trendora/features/auth/presentation/state/auth_state.dart';


final authViewModelProvider =
    NotifierProvider<AuthViewModel, AuthState>(() => AuthViewModel());

class AuthViewModel extends Notifier<AuthState> {
  // Remove 'late' and make them nullable, or initialize in build
  RegisterUsecase? _registerUsecase;
  LoginUsecase? _loginUsecase;
  LogoutUsecase? _logoutUsecase;
  GetCurrentUserUsecase? _getCurrentUserUsecase;

  @override
  AuthState build() {
    print("🔧 Building AuthViewModel...");
    
    try {
      _registerUsecase = ref.read(registerUsecaseProvider);
      print("✅ RegisterUsecase: $_registerUsecase");
      
      _loginUsecase = ref.read(loginUseCaseProvider);
      print("✅ LoginUsecase: $_loginUsecase");
      
      _logoutUsecase = ref.read(logoutUsecaseProvider);
      print("✅ LogoutUsecase: $_logoutUsecase");
      
      _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
      print("✅ GetCurrentUserUsecase: $_getCurrentUserUsecase");
    } catch (e) {
      print("❌ Error initializing: $e");
    }
    
    return AuthState.initial();
  }

  /// Register new user
  Future<void> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String? address,
  }) async {
    print("🚀 Register method called");
    print("📝 _registerUsecase is null? ${_registerUsecase == null}");
    
    if (_registerUsecase == null) {
      print("❌ RegisterUsecase is null!");
      state = AuthState.error("Registration service not initialized");
      return;
    }

    print("✅ Starting registration process...");
    state = AuthState.loading();

    final params = RegisterUsecaseParams(
      fullName: fullName,
      username: username,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      address: address,
    );

    print("📤 Calling register usecase with params: $params");
    final result = await _registerUsecase!(params);

    result.fold(
      (failure) {
        print("❌ Registration failed: ${failure.message}");
        state = AuthState.error(failure.message);
      },
      (_) {
        print("✅ Registration successful!");
        state = AuthState.registered("Registration successful");
      },
    );
  }

  /// Login user
  Future<void> login({
    required String email,
    required String password,
  }) async {
    print("🚀 Login method called");
    print("📝 _loginUsecase is null? ${_loginUsecase == null}");
    
    if (_loginUsecase == null) {
      print("❌ LoginUsecase is null!");
      state = AuthState.error("Login service not initialized");
      return;
    }

    print("✅ Starting login process...");
    state = AuthState.loading();

    final params = LoginUsecaseParams(
      email: email,
      password: password,
    );

    print("📤 Calling login usecase");
    final result = await _loginUsecase!(params);

    result.fold(
      (failure) {
        print("❌ Login failed: ${failure.message}");
        state = AuthState.error(failure.message);
      },
      (entity) {
        print("✅ Login successful!");
        state = AuthState.authenticated(entity);
      },
    );
  }

  /// Logout user
  Future<void> logout() async {
    if (_logoutUsecase == null) {
      state = AuthState.error("Logout service not initialized");
      return;
    }

    state = AuthState.loading();

    final result = await _logoutUsecase!();

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (_) => state = const AuthState(
        status: AuthStatus.unauthenticated,
      ),
    );
  }

  /// Get current user
  Future<void> getCurrentUser() async {
    if (_getCurrentUserUsecase == null) {
      state = AuthState.error("Get user service not initialized");
      return;
    }

    state = AuthState.loading();

    final result = await _getCurrentUserUsecase!();

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (entity) => state = AuthState.authenticated(entity),
    );
  }
}