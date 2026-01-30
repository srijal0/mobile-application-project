import 'package:fashion_store_trendora/features/auth/presentation/pages/sign_up_screen.dart';
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
  group('SignUpPage Widget Tests', () {
    
    // Test 1: Widget renders with all required UI elements
    testWidgets('should display all signup UI elements', (tester) async {
      // Arrange & Act
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authViewModelProvider.overrideWith(() => MockAuthViewModel()),
          ],
          child: MediaQuery(
            data: const MediaQueryData(size: Size(1080, 1920)),
            child: const MaterialApp(
              home: SignUpPage(),
            ),
          ),
        ),
      );

      // Wait for the widget to fully render
      await tester.pumpAndSettle();

      // Assert - Check all widgets are present
      expect(find.text('Create Account'), findsOneWidget); // Title
      expect(find.byType(TextFormField), findsNWidgets(5)); // All 5 fields
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text("Already have an account? "), findsOneWidget);
      expect(find.text("Login"), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.alternate_email), findsOneWidget);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsNWidgets(2));
    });

    // Test 2: Full Name validation - empty shows error
    testWidgets('should show error when full name is empty', (tester) async {
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
              home: SignUpPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Scroll to bottom to find signup button
      await tester.dragUntilVisible(
        find.widgetWithText(ElevatedButton, 'Sign Up'),
        find.byType(SingleChildScrollView),
        const Offset(0, -50),
      );

      // Tap signup without entering full name
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Full name is required'), findsOneWidget);
    });

    // Test 3: Username validation - too short shows error
    testWidgets('should show error when username is less than 3 characters', (tester) async {
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
              home: SignUpPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Find fields by their label text
      final fullNameField = find.ancestor(
        of: find.text('Full Name'),
        matching: find.byType(TextFormField),
      );
      
      final usernameField = find.ancestor(
        of: find.text('Username'),
        matching: find.byType(TextFormField),
      );

      // Enter data
      await tester.enterText(fullNameField, 'John Doe');
      await tester.enterText(usernameField, 'ab'); // Only 2 chars

      // Scroll to signup button
      await tester.dragUntilVisible(
        find.widgetWithText(ElevatedButton, 'Sign Up'),
        find.byType(SingleChildScrollView),
        const Offset(0, -50),
      );
      
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Username must be at least 3 characters'), findsOneWidget);
    });

    // Test 4: Email validation - invalid format shows error
    testWidgets('should show error when email format is invalid', (tester) async {
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
              home: SignUpPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Find fields by label
      final fullNameField = find.ancestor(
        of: find.text('Full Name'),
        matching: find.byType(TextFormField),
      );
      
      final usernameField = find.ancestor(
        of: find.text('Username'),
        matching: find.byType(TextFormField),
      );
      
      final emailField = find.ancestor(
        of: find.text('Email'),
        matching: find.byType(TextFormField),
      );

      // Enter data
      await tester.enterText(fullNameField, 'John Doe');
      await tester.enterText(usernameField, 'johndoe');
      await tester.enterText(emailField, 'invalidemail'); // Invalid email

      // Scroll to signup button
      await tester.dragUntilVisible(
        find.widgetWithText(ElevatedButton, 'Sign Up'),
        find.byType(SingleChildScrollView),
        const Offset(0, -50),
      );
      
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    // Test 5: Password validation - passwords don't match shows error
    testWidgets('should show error when passwords do not match', (tester) async {
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
              home: SignUpPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Find fields by label
      final fullNameField = find.ancestor(
        of: find.text('Full Name'),
        matching: find.byType(TextFormField),
      );
      
      final usernameField = find.ancestor(
        of: find.text('Username'),
        matching: find.byType(TextFormField),
      );
      
      final emailField = find.ancestor(
        of: find.text('Email'),
        matching: find.byType(TextFormField),
      );
      
      final passwordField = find.ancestor(
        of: find.text('Password'),
        matching: find.byType(TextFormField),
      );
      
      final confirmPasswordField = find.ancestor(
        of: find.text('Confirm Password'),
        matching: find.byType(TextFormField),
      );

      // Enter data
      await tester.enterText(fullNameField, 'John Doe');
      await tester.enterText(usernameField, 'johndoe');
      await tester.enterText(emailField, 'john@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'password456'); // Different

      // Scroll to signup button
      await tester.dragUntilVisible(
        find.widgetWithText(ElevatedButton, 'Sign Up'),
        find.byType(SingleChildScrollView),
        const Offset(0, -50),
      );
      
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

  });
}
