import 'package:fashion_store_trendora/core/api/api_client.dart';
import 'package:fashion_store_trendora/core/api/api_endpoints.dart';
import 'package:fashion_store_trendora/core/services/storage/user_session.dart';
import 'package:fashion_store_trendora/features/auth/data/datasources/auth_datasource.dart';
import 'package:fashion_store_trendora/features/auth/data/models/auth_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDatasourceProvider = Provider<IAuthRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final userSessionService = ref.read(userSessionServiceProvider);

  return AuthRemoteDatasource(
    apiClient: apiClient,
    userSessionService: userSessionService,
  );
});

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  })  : _apiClient = apiClient,
        _userSessionService = userSessionService;

  // ===================== LOGIN =====================
  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.userLogin,
      data: {
        "email": email,
        "password": password,
      },
    );

    final responseData = response.data;

    // Safety check
    if (responseData is! Map<String, dynamic>) {
      return null;
    }

    if (responseData["success"] == true && responseData["data"] != null) {
      final userData = responseData["data"] as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(userData);

      // Save user session
      await _userSessionService.saveUserSession(
        userId: user.authId!,
        email: user.email,
        username: user.username,
        fullName: user.fullName,
      );

      return user;
    }

    return null;
  }

  // ===================== REGISTER =====================
  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.userRegister,
      data: user.toJson(),
    );

    final responseData = response.data;

    // If backend returns non-JSON, just return input user
    if (responseData is! Map<String, dynamic>) {
      return user;
    }

    if (responseData["success"] == true && responseData["data"] != null) {
      final userData = responseData["data"] as Map<String, dynamic>;
      return AuthApiModel.fromJson(userData);
    }

    return user;
  }

  @override
  Future<AuthApiModel?> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<bool> logout() {
    throw UnimplementedError();
  }
}
