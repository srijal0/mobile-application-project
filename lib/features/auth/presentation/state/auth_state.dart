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

  /// Create a new state with updated values
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
      successMessage: clearMessage ? null : successMessage ?? this.successMessage,
    );
  }

  /// Initial empty state
  factory AuthState.initial() {
    return const AuthState(
      status: AuthStatus.initial,
    );
  }

  /// Loading state
  factory AuthState.loading() {
    return const AuthState(
      status: AuthStatus.loading,
    );
  }

  /// Authenticated state
  factory AuthState.authenticated(AuthEntity entity) {
    return AuthState(
      status: AuthStatus.authenticated,
      entity: entity,
    );
  }

  /// Error state
  factory AuthState.error(String message) {
    return AuthState(
      status: AuthStatus.error,
      errorMessage: message,
    );
  }

  /// Registered state
  factory AuthState.registered(String message) {
    return AuthState(
      status: AuthStatus.registered,
      successMessage: message,
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
