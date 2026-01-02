// lib/core/usecases/usecase.dart
import 'package:dartz/dartz.dart';
import 'package:fashion_store_trendora/core/error/failures.dart';

/// Base interface for use cases that require parameters
abstract interface class UseCaseWithParams<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

/// Base interface for use cases that do not require parameters
abstract interface class UseCaseWithoutParams<SuccessType> {
  Future<Either<Failure, SuccessType>> call();
}
