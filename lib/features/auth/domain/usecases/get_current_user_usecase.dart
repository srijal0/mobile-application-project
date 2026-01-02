import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashion_store_trendora/core/error/failures.dart';
import 'package:fashion_store_trendora/features/auth/domain/repositories/auth_repository.dart';
import 'package:fashion_store_trendora/features/auth/data/repositories/auth_repository.dart' as data_repo;
import 'package:fashion_store_trendora/features/auth/domain/entities/auth_entity.dart';

// Provider
final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
	final authRepository = ref.watch(data_repo.authRepositoryProvider);
	return GetCurrentUserUsecase(authRepository: authRepository);
});

/// Get current user use case implementation
class GetCurrentUserUsecase {
	final IAuthRepository _authRepository;

	GetCurrentUserUsecase({required IAuthRepository authRepository})
			: _authRepository = authRepository;

	Future<Either<Failure, AuthEntity>> call() {
		return _authRepository.getCurrentUser();
	}
}
