import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_store_trendora/features/auth/data/models/auth_hive_model.dart';
import 'package:fashion_store_trendora/features/auth/domain/entities/auth_entity.dart';

void main() {
  group('AuthHiveModel Tests', () {
    const tFullName = 'Srijal Shrestha';
    const tEmail = 'srijal@example.com';
    const tUsername = 'srijal0';
    const tPassword = 'Test@1234';
    const tProfilePicture = 'https://example.com/pic.jpg';

    final tAuthHiveModel = AuthHiveModel(
      fullName: tFullName,
      email: tEmail,
      username: tUsername,
      password: tPassword,
      profilePicture: tProfilePicture,
    );

    final tAuthEntity = AuthEntity(
      fullName: tFullName,
      email: tEmail,
      username: tUsername,
      password: tPassword,
      profilePicture: tProfilePicture,
    );

    group('constructor', () {
      test('should auto-generate authId when not provided', () {
        // Act
        final model = AuthHiveModel(
          fullName: tFullName,
          email: tEmail,
          username: tUsername,
        );

        // Assert
        expect(model.authId, isNotNull);
        expect(model.authId, isNotEmpty);
      });

      test('should use provided authId', () {
        // Arrange
        const customId = 'custom-id-123';

        // Act
        final model = AuthHiveModel(
          authId: customId,
          fullName: tFullName,
          email: tEmail,
          username: tUsername,
        );

        // Assert
        expect(model.authId, equals(customId));
      });

      test('should have null optional fields when not provided', () {
        // Act
        final model = AuthHiveModel(
          fullName: tFullName,
          email: tEmail,
          username: tUsername,
        );

        // Assert
        expect(model.password, isNull);
        expect(model.profilePicture, isNull);
      });
    });

    group('toEntity()', () {
      test('should convert AuthHiveModel to AuthEntity correctly', () {
        // Act
        final result = tAuthHiveModel.toEntity();

        // Assert
        expect(result, isA<AuthEntity>());
        expect(result.fullName, equals(tFullName));
        expect(result.email, equals(tEmail));
        expect(result.username, equals(tUsername));
        expect(result.password, equals(tPassword));
        expect(result.profilePicture, equals(tProfilePicture));
        expect(result.authId, equals(tAuthHiveModel.authId));
      });
    });

    group('fromEntity()', () {
      test('should create AuthHiveModel from AuthEntity correctly', () {
        // Act
        final result = AuthHiveModel.fromEntity(tAuthEntity);

        // Assert
        expect(result, isA<AuthHiveModel>());
        expect(result.fullName, equals(tFullName));
        expect(result.email, equals(tEmail));
        expect(result.username, equals(tUsername));
        expect(result.password, equals(tPassword));
        expect(result.profilePicture, equals(tProfilePicture));
      });

      test('should preserve authId from entity when converting', () {
        // Arrange
        const authEntity = AuthEntity(
          authId: 'entity-id-456',
          fullName: tFullName,
          email: tEmail,
          username: tUsername,
        );

        // Act
        final model = AuthHiveModel.fromEntity(authEntity);

        // Assert
        expect(model.authId, equals('entity-id-456'));
      });
    });

    group('toEntityList()', () {
      test('should convert list of AuthHiveModels to list of AuthEntities', () {
        // Arrange
        final models = [
          AuthHiveModel(fullName: 'User One', email: 'one@example.com', username: 'user1'),
          AuthHiveModel(fullName: 'User Two', email: 'two@example.com', username: 'user2'),
        ];

        // Act
        final result = AuthHiveModel.toEntityList(models);

        // Assert
        expect(result, isA<List<AuthEntity>>());
        expect(result.length, equals(2));
        expect(result[0].fullName, equals('User One'));
        expect(result[1].fullName, equals('User Two'));
      });

      test('should return empty list when given empty list', () {
        // Act
        final result = AuthHiveModel.toEntityList([]);

        // Assert
        expect(result, isEmpty);
      });
    });

    group('roundtrip conversion', () {
      test('entity → hive model → entity should preserve all fields', () {
        // Arrange
        const original = AuthEntity(
          authId: 'round-trip-id',
          fullName: tFullName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
          profilePicture: tProfilePicture,
        );

        // Act
        final hiveModel = AuthHiveModel.fromEntity(original);
        final result = hiveModel.toEntity();

        // Assert
        expect(result.authId, equals(original.authId));
        expect(result.fullName, equals(original.fullName));
        expect(result.email, equals(original.email));
        expect(result.username, equals(original.username));
        expect(result.password, equals(original.password));
        expect(result.profilePicture, equals(original.profilePicture));
      });
    });
  });
}