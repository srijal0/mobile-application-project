// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import 'package:fashion_store_trendora/core/error/failures.dart';
import 'package:fashion_store_trendora/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthRepository {
  /// Register a new user
  Future<Either<Failure, bool>> register(AuthEntity entity);

  /// Login user with email + password
  Future<Either<Failure, AuthEntity>> login(String email, String password);

  /// Get the current logged-in user
  Future<Either<Failure, AuthEntity>> getCurrentUser();

  /// Logout the current user
  Future<Either<Failure, bool>> logout();
}
