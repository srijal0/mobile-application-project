import 'package:fashion_store_trendora/features/auth/data/models/auth_api_model.dart';
import 'package:fashion_store_trendora/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthLocalDatasource {
  /// Register a new user in Hive
  Future<bool> register(AuthHiveModel model);

  /// Login user with email + password
  Future<AuthHiveModel?> login(String email, String password);

  /// Get the current logged-in user
  Future<AuthHiveModel?> getCurrentUser();

  /// Logout the current user
  Future<bool> logout();
}
abstract interface class IAuthRemoteDatasource {
  Future<AuthApiModel> register(AuthApiModel model);
  Future<AuthApiModel?> login(String email, String password);
  Future<AuthApiModel?> getCurrentUser();
  Future<bool> logout();
}
