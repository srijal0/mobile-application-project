import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_store_trendora/features/auth/domain/entities/auth_entity.dart';

void main() {
  group('AuthEntity Tests', () {
    const tAuthEntity = AuthEntity(
      authId: 'test-id-123',
      fullName: 'Srijal Shrestha',
      email: 'srijal@example.com',
      username: 'srijal0',
      password: 'Test@1234',
      confirmPassword: 'Test@1234',
      profilePicture: 'https://example.com/pic.jpg',
      phoneNumber: '9800000000',
      address: 'Kathmandu, Nepal',
    );

    group('constructor', () {
      test('should create AuthEntity with all required fields', () {
        // Act
        const entity = AuthEntity(
          fullName: 'Srijal Shrestha',
          email: 'srijal@example.com',
          username: 'srijal0',
        );

        // Assert
        expect(entity.fullName, equals('Srijal Shrestha'));
        expect(entity.email, equals('srijal@example.com'));
        expect(entity.username, equals('srijal0'));
      });

      test('should have null optional fields when not provided', () {
        // Act
        const entity = AuthEntity(
          fullName: 'Srijal Shrestha',
          email: 'srijal@example.com',
          username: 'srijal0',
        );

        // Assert
        expect(entity.authId, isNull);
        expect(entity.password, isNull);
        expect(entity.confirmPassword, isNull);
        expect(entity.profilePicture, isNull);
        expect(entity.phoneNumber, isNull);
        expect(entity.address, isNull);
      });

      test('should store all provided fields correctly', () {
        expect(tAuthEntity.authId, equals('test-id-123'));
        expect(tAuthEntity.fullName, equals('Srijal Shrestha'));
        expect(tAuthEntity.email, equals('srijal@example.com'));
        expect(tAuthEntity.username, equals('srijal0'));
        expect(tAuthEntity.password, equals('Test@1234'));
        expect(tAuthEntity.confirmPassword, equals('Test@1234'));
        expect(tAuthEntity.profilePicture, equals('https://example.com/pic.jpg'));
        expect(tAuthEntity.phoneNumber, equals('9800000000'));
        expect(tAuthEntity.address, equals('Kathmandu, Nepal'));
      });
    });

    group('Equatable - props', () {
      test('should return true when two entities have same props', () {
        // Arrange
        const entity1 = AuthEntity(
          authId: 'same-id',
          fullName: 'Srijal Shrestha',
          email: 'srijal@example.com',
          username: 'srijal0',
        );

        const entity2 = AuthEntity(
          authId: 'same-id',
          fullName: 'Srijal Shrestha',
          email: 'srijal@example.com',
          username: 'srijal0',
        );

        // Assert
        expect(entity1, equals(entity2));
      });

      test('should return false when two entities have different props', () {
        // Arrange
        const entity1 = AuthEntity(
          authId: 'id-1',
          fullName: 'Srijal Shrestha',
          email: 'srijal@example.com',
          username: 'srijal0',
        );

        const entity2 = AuthEntity(
          authId: 'id-2',
          fullName: 'Different Name',
          email: 'different@example.com',
          username: 'different0',
        );

        // Assert
        expect(entity1, isNot(equals(entity2)));
      });

      test('should have correct props list length', () {
        expect(tAuthEntity.props.length, equals(9));
      });

      test('should include all fields in props', () {
        expect(tAuthEntity.props, contains('test-id-123'));
        expect(tAuthEntity.props, contains('Srijal Shrestha'));
        expect(tAuthEntity.props, contains('srijal@example.com'));
        expect(tAuthEntity.props, contains('srijal0'));
        expect(tAuthEntity.props, contains('Test@1234'));
        expect(tAuthEntity.props, contains('9800000000'));
        expect(tAuthEntity.props, contains('Kathmandu, Nepal'));
      });

      test('entities with null optional fields should equal each other', () {
        // Arrange
        const entity1 = AuthEntity(
          fullName: 'Srijal Shrestha',
          email: 'srijal@example.com',
          username: 'srijal0',
        );

        const entity2 = AuthEntity(
          fullName: 'Srijal Shrestha',
          email: 'srijal@example.com',
          username: 'srijal0',
        );

        // Assert
        expect(entity1, equals(entity2));
      });
    });
  });
}