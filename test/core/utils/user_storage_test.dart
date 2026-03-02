import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_store_trendora/core/utils/user_storage.dart';

void main() {
  setUp(() {
    // Clear user before each test to ensure isolation
    UserStorage.clearUser();
  });

  group('UserStorage Tests', () {
    group('register()', () {
      test('should register a user and store data correctly', () {
        // Arrange
        const fullName = 'Srijal Shrestha';
        const username = 'srijal0';
        const email = 'srijal@example.com';
        const password = 'Test@1234';

        // Act
        UserStorage.register(
          fullName: fullName,
          username: username,
          email: email,
          password: password,
        );

        // Assert
        expect(UserStorage.fullName, equals(fullName));
        expect(UserStorage.username, equals(username));
        expect(UserStorage.email, equals(email));
        expect(UserStorage.password, equals(password));
      });

      test('should overwrite existing user when registering again', () {
        // Arrange
        UserStorage.register(
          fullName: 'Old User',
          username: 'olduser',
          email: 'old@example.com',
          password: 'OldPass',
        );

        // Act
        UserStorage.register(
          fullName: 'New User',
          username: 'newuser',
          email: 'new@example.com',
          password: 'NewPass',
        );

        // Assert
        expect(UserStorage.fullName, equals('New User'));
        expect(UserStorage.email, equals('new@example.com'));
      });
    });

    group('loginUser()', () {
      test('should return User when credentials match', () {
        // Arrange
        UserStorage.register(
          fullName: 'Srijal Shrestha',
          username: 'srijal0',
          email: 'srijal@example.com',
          password: 'Test@1234',
        );

        // Act
        final user = UserStorage.loginUser('srijal@example.com', 'Test@1234');

        // Assert
        expect(user, isNotNull);
        expect(user!.email, equals('srijal@example.com'));
        expect(user.fullName, equals('Srijal Shrestha'));
      });

      test('should return null when email is incorrect', () {
        // Arrange
        UserStorage.register(
          fullName: 'Srijal Shrestha',
          username: 'srijal0',
          email: 'srijal@example.com',
          password: 'Test@1234',
        );

        // Act
        final user = UserStorage.loginUser('wrong@example.com', 'Test@1234');

        // Assert
        expect(user, isNull);
      });

      test('should return null when password is incorrect', () {
        // Arrange
        UserStorage.register(
          fullName: 'Srijal Shrestha',
          username: 'srijal0',
          email: 'srijal@example.com',
          password: 'Test@1234',
        );

        // Act
        final user = UserStorage.loginUser('srijal@example.com', 'WrongPass');

        // Assert
        expect(user, isNull);
      });

      test('should return null when no user is registered', () {
        // Act
        final user = UserStorage.loginUser('srijal@example.com', 'Test@1234');

        // Assert
        expect(user, isNull);
      });
    });

    group('getCurrentUser()', () {
      test('should return null when no user is registered', () {
        expect(UserStorage.getCurrentUser(), isNull);
      });

      test('should return registered user', () {
        // Arrange
        UserStorage.register(
          fullName: 'Srijal Shrestha',
          username: 'srijal0',
          email: 'srijal@example.com',
          password: 'Test@1234',
        );

        // Act
        final user = UserStorage.getCurrentUser();

        // Assert
        expect(user, isNotNull);
        expect(user!.username, equals('srijal0'));
      });
    });

    group('clearUser()', () {
      test('should clear user data after logout', () {
        // Arrange
        UserStorage.register(
          fullName: 'Srijal Shrestha',
          username: 'srijal0',
          email: 'srijal@example.com',
          password: 'Test@1234',
        );

        // Act
        UserStorage.clearUser();

        // Assert
        expect(UserStorage.getCurrentUser(), isNull);
        expect(UserStorage.fullName, isNull);
        expect(UserStorage.email, isNull);
      });
    });
  });
}