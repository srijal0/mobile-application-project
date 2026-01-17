import 'package:equatable/equatable.dart';
import 'package:fashion_store_trendora/features/auth/domain/entities/auth_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  registered,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthEntity? entity;
  final String? errorMessage;
  final String? successMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.entity,
    this.errorMessage,
    this.successMessage,
  });

  /* =======================
     ✅ STATE CHECK GETTERS
     ======================= */

  bool get isInitial => status == AuthStatus.initial;

  bool get isLoading => status == AuthStatus.loading;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  bool get isRegistered => status == AuthStatus.registered;

  bool get isError => status == AuthStatus.error;

  /* =======================
     ✅ COPY WITH
     ======================= */

  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? entity,
    String? errorMessage,
    String? successMessage,
    bool clearMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      entity: entity ?? this.entity,
      errorMessage: clearMessage ? null : errorMessage ?? this.errorMessage,
      successMessage:
          clearMessage ? null : successMessage ?? this.successMessage,
    );
  }

  /* =======================
     ✅ FACTORY STATES
     ======================= */

  factory AuthState.initial() {
    return const AuthState(
      status: AuthStatus.initial,
    );
  }

  factory AuthState.loading() {
    return const AuthState(
      status: AuthStatus.loading,
    );
  }

  factory AuthState.authenticated(AuthEntity entity) {
    return AuthState(
      status: AuthStatus.authenticated,
      entity: entity,
    );
  }

  factory AuthState.registered(String message) {
    return AuthState(
      status: AuthStatus.registered,
      successMessage: message,
    );
  }

  factory AuthState.error(String message) {
    return AuthState(
      status: AuthStatus.error,
      errorMessage: message,
    );
  }

  factory AuthState.unauthenticated() {
    return const AuthState(
      status: AuthStatus.unauthenticated,
    );
  }

  @override
  List<Object?> get props => [
        status,
        entity,
        errorMessage,
        successMessage,
      ];
}
