import 'package:fashion_store_trendora/features/auth/data/models/auth_api_model.dart';
import 'package:fashion_store_trendora/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('AuthApiModel', () {
    
    // Test 1: toJson should convert AuthApiModel to Map with correct keys
    test('toJson should convert model to JSON with backend expected keys', () {
      // Arrange
      final model = AuthApiModel(
        authId: '123',
        fullName: 'Salman Khan',
        email: 'salman@example.com',
        username: 'johndoe',
        password: 'password123',
        confirmPassword: 'password123',
        profilePicture: 'https://example.com/pic.jpg',
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json, isA<Map<String, dynamic>>());
      expect(json['name'], 'Salman Khan'); // Backend expects "name" not "fullName"
      expect(json['email'], 'salman@example.com');
      expect(json['username'], 'salman');
      expect(json['password'], 'password123');
      expect(json['confirmPassword'], 'password123');
      expect(json['profilePicture'], 'https://example.com/pic.jpg');
      expect(json.containsKey('authId'), false); // authId should NOT be in toJson
    });

    // Test 2: fromJson should create AuthApiModel from backend response
    test('fromJson should parse backend JSON response correctly', () {
      // Arrange - Simulating backend response
      final json = {
        '_id': '123',
        'name': 'Salman Khan', // Backend returns "name"
        'email': 'salman@example.com',
        'username': 'salman',
        'profilePicture': 'https://example.com/pic.jpg',
      };

      // Act
      final model = AuthApiModel.fromJson(json);

      // Assert
      expect(model.authId, '123');
      expect(model.fullName, 'Salman Khan');
      expect(model.email, 'salman@example.com');
      expect(model.username, 'salman');
      expect(model.profilePicture, 'https://example.com/pic.jpg');
      expect(model.password, null); // Password not in response
      expect(model.confirmPassword, null);
    });

    // Test 3: fromJson should fallback to username if name is missing
    test('fromJson should use username as fullName when name is null', () {
      // Arrange - Backend response without "name" field
      final json = {
        '_id': '123',
        'email': 'salman@example.com',
        'username': 'salman',
      };

      // Act
      final model = AuthApiModel.fromJson(json);

      // Assert
      expect(model.fullName, 'Salman Khan'); // Should fallback to username
      expect(model.username, 'salman');
    });

    // Test 4: toEntity should convert AuthApiModel to AuthEntity
    test('toEntity should convert model to domain entity', () {
      // Arrange
      final model = AuthApiModel(
        authId: '123',
        fullName: 'Salman Khan',
        email: 'salman@example.com',
        username: 'salman',
        password: 'password123',
        confirmPassword: 'password123',
        profilePicture: 'https://example.com/pic.jpg',
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity, isA<AuthEntity>());
      expect(entity.authId, '123');
      expect(entity.fullName, 'Salman Khan');
      expect(entity.email, 'salman@example.com');
      expect(entity.username, 'salman');
      expect(entity.confirmPassword, 'password123');
      expect(entity.profilePicture, 'https://example.com/pic.jpg');
    });

    // Test 5: fromEntity should convert AuthEntity to AuthApiModel
    test('fromEntity should convert domain entity to model', () {
      // Arrange
      const entity = AuthEntity(
        authId: '123',
        fullName: 'Salman Khan',
        email: 'salman@example.com',
        username: 'salman',
        password: 'password123',
        confirmPassword: 'password123',
        profilePicture: 'https://example.com/pic.jpg',
      );

      // Act
      final model = AuthApiModel.fromEntity(entity);

      // Assert
      expect(model, isA<AuthApiModel>());
      expect(model.authId, '123');
      expect(model.fullName, 'Salman Khan');
      expect(model.email, 'salman@example.com');
      expect(model.username, 'salman');
      expect(model.password, 'password123');
      expect(model.confirmPassword, 'password123');
      expect(model.profilePicture, 'https://example.com/pic.jpg');
    });

  });
}