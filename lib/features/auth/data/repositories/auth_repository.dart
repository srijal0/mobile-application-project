import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fashion_store_trendora/core/error/failures.dart';
import 'package:fashion_store_trendora/core/services/connectivity/network_info.dart';
import 'package:fashion_store_trendora/features/auth/data/datasources/auth_datasource.dart';
import 'package:fashion_store_trendora/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:fashion_store_trendora/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:fashion_store_trendora/features/auth/data/models/auth_api_model.dart';
import 'package:fashion_store_trendora/features/auth/data/models/auth_hive_model.dart';
import 'package:fashion_store_trendora/features/auth/domain/entities/auth_entity.dart';
import 'package:fashion_store_trendora/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authLocalDatasource = ref.watch(authLocalDatasourceProvider);
  final authRemoteDatasource = ref.watch(authRemoteDatasourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return AuthRepository(
    authLocalDatasource: authLocalDatasource,
    authRemoteDatasource: authRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDatasource _authLocalDatasource;
  final IAuthRemoteDatasource _authRemoteDatasource;
  final INetworkInfo _networkInfo;


  AuthRepository({
    required IAuthLocalDatasource authLocalDatasource,
    required IAuthRemoteDatasource authRemoteDatasource,
    required INetworkInfo networkInfo,

  }) : _authLocalDatasource = authLocalDatasource,
       _authRemoteDatasource = authRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _authRemoteDatasource.login(email, password);
        if (result != null) {
          final entity = result.toEntity();
          return Right(entity);
        }
        return Left(ApiFailure(message: "Invalid credentials"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(message: e.response?.data["message"] ?? "Login Failed"),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _authLocalDatasource.login(email, password);

        if (model != null) {
          final entity = model.toEntity();
          return Right(entity);
        }

        return Left(LocalDataBaseFailure(message: "User not found"));
      } catch (e) {
        return Left(LocalDataBaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authLocalDatasource.logout();
      if (result) return Right(true);
      return Left(LocalDataBaseFailure(message: "Failed to logout"));
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    if (await _networkInfo.isConnected) {
      try {
        final userModel = AuthApiModel.fromEntity(entity);
        await _authRemoteDatasource.register(userModel);
        return Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Registration failed",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = AuthHiveModel.fromEntity(entity);
        final result = await _authLocalDatasource.register(model);
        if (result) return Right(true);
        return Left(LocalDataBaseFailure(message: "Failed to register user"));
      } catch (e) {
        return Left(LocalDataBaseFailure(message: e.toString()));
      }
    }
  }
}