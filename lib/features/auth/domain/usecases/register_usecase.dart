import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fashion_store_trendora/core/usecases/app_usecase.dart';
import 'package:fashion_store_trendora/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashion_store_trendora/core/error/failures.dart';

import 'package:fashion_store_trendora/features/auth/domain/entities/auth_entity.dart';
import 'package:fashion_store_trendora/features/auth/domain/repositories/auth_repository.dart';

// Provider
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

/// Parameters for register use case
class RegisterUsecaseParams extends Equatable {
  final String fullName;
  final String email;
  final String username;
  final String password;
  final String phoneNumber;
  final String? address;

  const RegisterUsecaseParams({
    required this.fullName,
    required this.email,
    required this.username,
    required this.password,
    required this.phoneNumber,
    this.address,
  });

  @override
  List<Object?> get props => [fullName, email, username, password, phoneNumber, address];
}

/// Register use case implementation
class RegisterUsecase
    implements UseCaseWithParams<bool, RegisterUsecaseParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
      fullName: params.fullName,
      email: params.email,
      username: params.username,
      password: params.password,
      phoneNumber: params.phoneNumber,
      address: params.address,
    );
    return _authRepository.register(entity);
  }
}