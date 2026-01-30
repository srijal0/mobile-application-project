import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fashion_store_trendora/core/api/api_client.dart';
import 'package:fashion_store_trendora/core/api/api_endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadServiceProvider = Provider<UploadService>((ref) {
  return UploadService(ref.read(apiClientProvider));
});

class UploadService {
  final ApiClient _apiClient;

  UploadService(this._apiClient);

  // Upload profile image
  Future<Map<String, dynamic>> uploadProfileImage({
    required File imageFile,
    required String userId,
    ProgressCallback? onProgress,
  }) async {
    try {
      // Create form data
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
        'userId': userId,
      });

      // Upload using the uploadFile method from ApiClient
      final response = await _apiClient.uploadFile(
        ApiEndpoints.uploadProfileImage,
        formData: formData,
        onSendProgress: onProgress,
      );

      return response.data;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Get user profile image URL
  Future<String?> getProfileImage(String userId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getProfileImage(userId),
      );

      if (response.data['success'] == true) {
        return response.data['data']['imageUrl'];
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get profile image: $e');
    }
  }
}