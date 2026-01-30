import 'package:fashion_store_trendora/features/auth/presentation/pages/login_screen.dart';
import 'package:fashion_store_trendora/features/auth/presentation/state/auth_state.dart';
import 'package:fashion_store_trendora/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock AuthViewModel for testing
class MockAuthViewModel extends AuthViewModel {
  @override
  AuthState build() => AuthState.initial();
}

void main() {
  group('LoginPage Widget Tests', () {
    
    // Test 1: Widget renders with all required UI elements
    testWidgets('should display all login UI elements', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authViewModelProvider.overrideWith(() => MockAuthViewModel()),
          ],
          child: MediaQuery(
            data: const MediaQueryData(size: Size(1080, 1920)),
            child: const MaterialApp(
              home: LoginPage(),
            ),
          ),
        ),
      );

      // Assert - Check all widgets are present
      expect(find.text('TRENDORA'), findsOneWidget); // Logo text
      expect(find.byType(TextFormField), findsNWidgets(2)); // Email & Password
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text("Don’t have an account? "), findsOneWidget);
      expect(find.text("Sign Up"), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    // Test 2: Email validation - empty email shows error
    testWidgets('should show error when email is empty', (tester) async {
      // Arrange
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authViewModelProvider.overrideWith(() => MockAuthViewModel()),
          ],
          child: MediaQuery(
            data: const MediaQueryData(size: Size(1080, 1920)),
            child: const MaterialApp(
              home: LoginPage(),
            ),
          ),
        ),
      );

      // Act - Find and tap login button without entering email
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      await tester.tap(loginButton);
      await tester.pump(); // Trigger validation

      // Assert
      expect(find.text('Email is required'), findsOneWidget);
    });

    // Test 3: Password validation - empty password shows error
    testWidgets('should show error when password is empty', (tester) async {
      // Arrange
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authViewModelProvider.overrideWith(() => MockAuthViewModel()),
          ],
          child: MediaQuery(
            data: const MediaQueryData(size: Size(1080, 1920)),
            child: const MaterialApp(
              home: LoginPage(),
            ),
          ),
        ),
      );

      // Act - Enter valid email but no password
      final emailFields = find.byType(TextFormField);
      await tester.enterText(emailFields.first, 'test@example.com');
      
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      await tester.tap(loginButton);
      await tester.pump();

      // Assert
      expect(find.text('Password is required'), findsOneWidget);
    });

    // Test 4: Password validation - short password shows error
    testWidgets('should show error when password is less than 6 characters', (tester) async {
      // Arrange
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authViewModelProvider.overrideWith(() => MockAuthViewModel()),
          ],
          child: MediaQuery(
            data: const MediaQueryData(size: Size(1080, 1920)),
            child: const MaterialApp(
              home: LoginPage(),
            ),
          ),
        ),
      );

      // Act - Enter valid email but short password
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'test@example.com'); // Email
      await tester.enterText(textFields.last, 'pass1'); // Only 5 chars
      
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      await tester.tap(loginButton);
      await tester.pump();

      // Assert
      expect(find.text('Minimum 6 characters'), findsOneWidget);
    });

    // Test 5: User can enter text in email and password fields
    testWidgets('should allow user to enter email and password', (tester) async {
      // Arrange
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authViewModelProvider.overrideWith(() => MockAuthViewModel()),
          ],
          child: MediaQuery(
            data: const MediaQueryData(size: Size(1080, 1920)),
            child: const MaterialApp(
              home: LoginPage(),
            ),
          ),
        ),
      );

      // Act - Enter text in both fields
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'salman@example.com');
      await tester.enterText(textFields.last, 'password123');
      await tester.pump();

      // Assert - Check if text was entered
      expect(find.text('salman@example.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });

  });
}
