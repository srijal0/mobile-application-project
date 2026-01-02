// lib/features/auth/presentation/state/auth_state.dart
import 'package:equatable/equatable.dart';
import 'package:fashion_store_trendora/features/auth/domain/entities/auth_entity.dart';

/// Authentication status for Trendora
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  registering,
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

  /// Copy state with updated values
  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? entity,
    String? errorMessage,
    String? successMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      entity: entity ?? this.entity,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [status, entity, errorMessage, successMessage];
}
