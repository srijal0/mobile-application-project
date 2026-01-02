import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashion_store_trendora/core/error/failures.dart';
import 'package:fashion_store_trendora/features/auth/domain/repositories/auth_repository.dart';
import 'package:fashion_store_trendora/features/auth/data/repositories/auth_repository.dart' as data_repo;

// Provider
final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
	final authRepository = ref.watch(data_repo.authRepositoryProvider);
	return LogoutUsecase(authRepository: authRepository);
});

/// Logout use case implementation
class LogoutUsecase {
	final IAuthRepository _authRepository;

	LogoutUsecase({required IAuthRepository authRepository})
			: _authRepository = authRepository;

	Future<Either<Failure, bool>> call() {
		return _authRepository.logout();
	}
}
