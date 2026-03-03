import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_endpoints.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

class ApiClient {
  late final Dio _dio;

  ApiClient({bool useEmulator = false}) {
    final baseUrl = useEmulator
        ? ApiEndpoints.baseUrlEmulator
        : ApiEndpoints.baseUrlDevice;

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiEndpoints.connectionTimeout, // Duration for Dio 5.x
        receiveTimeout: ApiEndpoints.receiveTimeout,     // Duration for Dio 5.x
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // ================= INTERCEPTORS =================
    _dio.interceptors.add(_AuthInterceptor());

    // Retry on network issues
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
        retryEvaluator: (error, attempt) =>
            error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.connectionError,
      ),
    );

    // Logger in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
    }
  }

  Dio get dio => _dio;

  // ================= REQUEST METHODS =================
  Future<Response> get(String path,
          {Map<String, dynamic>? queryParameters, Options? option}) =>
      _dio.get(path, queryParameters: queryParameters, options: option);

  Future<Response> post(String path,
          {dynamic data, Map<String, dynamic>? queryParameters, Options? option}) =>
      _dio.post(path, data: data, queryParameters: queryParameters, options: option);

  Future<Response> put(String path,
          {dynamic data, Map<String, dynamic>? queryParameters, Options? option}) =>
      _dio.put(path, data: data, queryParameters: queryParameters, options: option);

  Future<Response> delete(String path,
          {dynamic data, Map<String, dynamic>? queryParameters, Options? option}) =>
      _dio.delete(path, data: data, queryParameters: queryParameters, options: option);

  Future<Response> uploadFile(String path,
          {required FormData formData, Options? options, ProgressCallback? onSendProgress}) =>
      _dio.post(path, data: formData, options: options, onSendProgress: onSendProgress);
}

// ================= AUTH INTERCEPTOR =================
class _AuthInterceptor extends Interceptor {
  final _storage = const FlutterSecureStorage();
  static const String _tokenKey = "auth_token";

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final publicEndPoints = [
      ApiEndpoints.genre,
      ApiEndpoints.userLogin,
      ApiEndpoints.userRegister,
    ];

    final isPublicGet = options.method == "GET" &&
        publicEndPoints.any((endpoint) => options.path.startsWith(endpoint));

    final isAuthEndpoint =
        options.path == ApiEndpoints.userLogin || options.path == ApiEndpoints.userRegister;

    if (!isPublicGet && !isAuthEndpoint) {
      final token = await _storage.read(key: _tokenKey);
      if (token != null) {
        options.headers["Authorization"] = "Bearer $token";
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _storage.delete(key: _tokenKey);
      // TODO: Add navigation to login page if needed
    }
    handler.next(err);
  }
}