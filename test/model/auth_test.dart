import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_store_trendora/features/auth/data/models/auth_api_model.dart';
import 'package:fashion_store_trendora/features/auth/data/models/auth_hive_model.dart';
import 'package:fashion_store_trendora/features/auth/domain/entities/auth_entity.dart';

// hack: flutter test --coverage
// hack: flutter pub run test_cov_console

void main() {
  group("Entity and Hive Model conversion", () {
    test('convert to entity from hive model', () {
      // Arrange
      final authHiveModel = AuthHiveModel(
        authId: "test-id-101",
        fullName: "John Doe",
        email: "john@example.com",
        username: "johndoe",
        password: "password123",
        profilePicture: "https://example.com/profile.jpg",
      );

      // Expected entity
      final expectedEntity = AuthEntity(
        authId: "test-id-101",
        fullName: "John Doe",
        email: "john@example.com",
        username: "johndoe",
        password: "password123",
        profilePicture: "https://example.com/profile.jpg",
      );

      // Act
      final actualEntity = authHiveModel.toEntity();

      // Assert
      expect(actualEntity.authId, expectedEntity.authId);
      expect(actualEntity.fullName, expectedEntity.fullName);
      expect(actualEntity.email, expectedEntity.email);
      expect(actualEntity.username, expectedEntity.username);
      expect(actualEntity.password, expectedEntity.password);
      expect(actualEntity.profilePicture, expectedEntity.profilePicture);
    });

    test("convert to hive model from entity", () {
      // Arrange
      final authEntity = AuthEntity(
        authId: "test-id-102",
        fullName: "Jane Smith",
        email: "jane@example.com",
        username: "janesmith",
        password: "securepass456",
        profilePicture: "https://example.com/jane.jpg",
      );

      // Expected model
      final expectedModel = AuthHiveModel(
        authId: "test-id-102",
        fullName: "Jane Smith",
        email: "jane@example.com",
        username: "janesmith",
        password: "securepass456",
        profilePicture: "https://example.com/jane.jpg",
      );

      // Act
      final actualModel = AuthHiveModel.fromEntity(authEntity);

      // Assert
      expect(actualModel.authId, expectedModel.authId);
      expect(actualModel.fullName, expectedModel.fullName);
      expect(actualModel.email, expectedModel.email);
      expect(actualModel.username, expectedModel.username);
      expect(actualModel.password, expectedModel.password);
      expect(actualModel.profilePicture, expectedModel.profilePicture);
    });

    test("convert list of hive models to entity list", () {
      // Arrange
      final hiveModels = [
        AuthHiveModel(
          authId: "id-1",
          fullName: "User One",
          email: "user1@example.com",
          username: "user1",
        ),
        AuthHiveModel(
          authId: "id-2",
          fullName: "User Two",
          email: "user2@example.com",
          username: "user2",
        ),
      ];

      // Act
      final entityList = AuthHiveModel.toEntityList(hiveModels);

      // Assert
      expect(entityList.length, 2);
      expect(entityList[0].fullName, "User One");
      expect(entityList[1].fullName, "User Two");
    });

    test("should generate UUID when authId is null", () {
      // Arrange & Act
      final model = AuthHiveModel(
        fullName: "Test User",
        email: "test@example.com",
        username: "testuser",
      );

      // Assert
      expect(model.authId, isNotNull);
      expect(model.authId, isNotEmpty);
    });
  });

  group("Json and Api Model conversion", () {
    test("convert from Json to Api model", () {
      // Arrange
      Map<String, dynamic> json = {
        "_id": "api-id-103",
        "username": "apiuser",
        "email": "api@example.com",
        "phoneNumber": "+1234567890",
        "address": "123 Main St",
        "profilePicture": "https://example.com/api-profile.jpg",
      };

      final expectedModel = AuthApiModel(
        authId: "api-id-103",
        fullName: "apiuser",
        email: "api@example.com",
        username: "apiuser",
        phoneNumber: "+1234567890",
        address: "123 Main St",
        profilePicture: "https://example.com/api-profile.jpg",
      );

      // Act
      final actualModel = AuthApiModel.fromJson(json);

      // Assert
      expect(actualModel.authId, expectedModel.authId);
      expect(actualModel.fullName, expectedModel.fullName);
      expect(actualModel.email, expectedModel.email);
      expect(actualModel.username, expectedModel.username);
      expect(actualModel.phoneNumber, expectedModel.phoneNumber);
      expect(actualModel.address, expectedModel.address);
      expect(actualModel.profilePicture, expectedModel.profilePicture);
    });

    test("convert to json from Api model", () {
      // Arrange
      final apiModel = AuthApiModel(
        fullName: "API User",
        email: "apiuser@example.com",
        username: "apiusername",
        password: "password123",
        confirmPassword: "password123",
        phoneNumber: "+9876543210",
        address: "456 Oak Ave",
        profilePicture: "https://example.com/user.jpg",
      );

      final expectedJson = {
        "name": "API User",
        "email": "apiuser@example.com",
        "username": "apiusername",
        "password": "password123",
        "confirmPassword": "password123",
        "phoneNumber": "+9876543210",
        "address": "456 Oak Ave",
        "profilePicture": "https://example.com/user.jpg",
      };

      // Act
      final actualJson = apiModel.toJson();

      // Assert
      expect(actualJson["name"], expectedJson["name"]);
      expect(actualJson["email"], expectedJson["email"]);
      expect(actualJson["username"], expectedJson["username"]);
      expect(actualJson["password"], expectedJson["password"]);
      expect(actualJson["confirmPassword"], expectedJson["confirmPassword"]);
      expect(actualJson["phoneNumber"], expectedJson["phoneNumber"]);
      expect(actualJson["address"], expectedJson["address"]);
      expect(actualJson["profilePicture"], expectedJson["profilePicture"]);
    });

    test("should use password as confirmPassword when confirmPassword is null", () {
      // Arrange
      final apiModel = AuthApiModel(
        fullName: "Test User",
        email: "test@example.com",
        username: "testuser",
        password: "mypassword",
        // confirmPassword is null
      );

      // Act
      final json = apiModel.toJson();

      // Assert
      expect(json["password"], "mypassword");
      expect(json["confirmPassword"], "mypassword");
    });

    test("convert to auth entity from Api model", () {
      // Arrange
      final apiModel = AuthApiModel(
        authId: "api-id-104",
        fullName: "Entity User",
        email: "entity@example.com",
        username: "entityuser",
        password: "entitypass",
        phoneNumber: "+1122334455",
        address: "789 Pine Rd",
        profilePicture: "https://example.com/entity.jpg",
      );

      final expectedEntity = AuthEntity(
        authId: "api-id-104",
        fullName: "Entity User",
        email: "entity@example.com",
        username: "entityuser",
        phoneNumber: "+1122334455",
        address: "789 Pine Rd",
        profilePicture: "https://example.com/entity.jpg",
      );

      // Act
      final actualEntity = apiModel.toEntity();

      // Assert
      expect(actualEntity.authId, expectedEntity.authId);
      expect(actualEntity.fullName, expectedEntity.fullName);
      expect(actualEntity.email, expectedEntity.email);
      expect(actualEntity.username, expectedEntity.username);
      expect(actualEntity.phoneNumber, expectedEntity.phoneNumber);
      expect(actualEntity.address, expectedEntity.address);
      expect(actualEntity.profilePicture, expectedEntity.profilePicture);
    });

    test("convert from entity to Api model", () {
      // Arrange
      final entity = AuthEntity(
        authId: "entity-id-105",
        fullName: "Model User",
        email: "model@example.com",
        username: "modeluser",
        password: "modelpass",
        phoneNumber: "+5566778899",
        address: "321 Elm St",
        profilePicture: "https://example.com/model.jpg",
      );

      final expectedModel = AuthApiModel(
        authId: "entity-id-105",
        fullName: "Model User",
        email: "model@example.com",
        username: "modeluser",
        password: "modelpass",
        phoneNumber: "+5566778899",
        address: "321 Elm St",
        profilePicture: "https://example.com/model.jpg",
      );

      // Act
      final actualModel = AuthApiModel.fromEntity(entity);

      // Assert
      expect(actualModel.authId, expectedModel.authId);
      expect(actualModel.fullName, expectedModel.fullName);
      expect(actualModel.email, expectedModel.email);
      expect(actualModel.username, expectedModel.username);
      expect(actualModel.password, expectedModel.password);
      expect(actualModel.phoneNumber, expectedModel.phoneNumber);
      expect(actualModel.address, expectedModel.address);
      expect(actualModel.profilePicture, expectedModel.profilePicture);
    });

    test("convert list of api models to entity list", () {
      // Arrange
      final apiModels = [
        AuthApiModel(
          authId: "api-1",
          fullName: "API User 1",
          email: "api1@example.com",
          username: "apiuser1",
        ),
        AuthApiModel(
          authId: "api-2",
          fullName: "API User 2",
          email: "api2@example.com",
          username: "apiuser2",
        ),
      ];

      // Act
      final entityList = AuthApiModel.toEntityList(apiModels);

      // Assert
      expect(entityList.length, 2);
      expect(entityList[0].fullName, "API User 1");
      expect(entityList[1].fullName, "API User 2");
      expect(entityList[0].email, "api1@example.com");
      expect(entityList[1].email, "api2@example.com");
    });
  });

  group("Edge cases and validation", () {
    test("handle null optional fields in Hive model", () {
      // Arrange
      final model = AuthHiveModel(
        fullName: "Minimal User",
        email: "minimal@example.com",
        username: "minimaluser",
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.password, isNull);
      expect(entity.profilePicture, isNull);
      expect(entity.fullName, isNotNull);
      expect(entity.email, isNotNull);
    });

    test("handle null optional fields in Api model", () {
      // Arrange
      final model = AuthApiModel(
        fullName: "Basic User",
        email: "basic@example.com",
        username: "basicuser",
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json["password"], isNull);
      expect(json["phoneNumber"], isNull);
      expect(json["address"], isNull);
      expect(json["profilePicture"], isNull);
    });

    test("handle empty string values", () {
      // Arrange
      final model = AuthApiModel(
        fullName: "",
        email: "",
        username: "",
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.fullName, isEmpty);
      expect(entity.email, isEmpty);
      expect(entity.username, isEmpty);
    });
  });
}