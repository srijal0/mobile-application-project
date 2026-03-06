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

// Helper to build the signup page
Widget buildSignUpPage() {
  return ProviderScope(
    overrides: [
      authViewModelProvider.overrideWith(() => MockAuthViewModel()),
    ],
    child: MediaQuery(
      data: const MediaQueryData(size: Size(1080, 1920)),
      child: const MaterialApp(
        home: SignUpPage(),
      ),
    ),
  );
}

void main() {
  group('SignUpPage Widget Tests', () {

    // Test 1: Widget renders with all required UI elements
    testWidgets('1. should display all signup UI elements', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildSignUpPage());
      await tester.pumpAndSettle();

      expect(find.text('Create Account'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(5));
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text("Already have an account? "), findsOneWidget);
      expect(find.text("Login"), findsOneWidget);
    });

    // Test 2: Full Name validation - empty shows error
    testWidgets('2. should show error when full name is empty', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildSignUpPage());
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.widgetWithText(ElevatedButton, 'Sign Up'),
        find.byType(SingleChildScrollView),
        const Offset(0, -50),
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Full name is required'), findsOneWidget);
    });

    // Test 3: Username validation - too short shows error
    testWidgets('3. should show error when username is less than 3 characters', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildSignUpPage());
      await tester.pumpAndSettle();

      final fullNameField = find.ancestor(
        of: find.text('Full Name'),
        matching: find.byType(TextFormField),
      );
      final usernameField = find.ancestor(
        of: find.text('Username'),
        matching: find.byType(TextFormField),
      );

      await tester.enterText(fullNameField, 'John Doe');
      await tester.enterText(usernameField, 'ab');

      await tester.dragUntilVisible(
        find.widgetWithText(ElevatedButton, 'Sign Up'),
        find.byType(SingleChildScrollView),
        const Offset(0, -50),
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Username must be at least 3 characters'), findsOneWidget);
    });

    // Test 4: Email validation - invalid format shows error
    testWidgets('4. should show error when email format is invalid', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildSignUpPage());
      await tester.pumpAndSettle();

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

      await tester.enterText(fullNameField, 'John Doe');
      await tester.enterText(usernameField, 'johndoe');
      await tester.enterText(emailField, 'invalidemail');

      await tester.dragUntilVisible(
        find.widgetWithText(ElevatedButton, 'Sign Up'),
        find.byType(SingleChildScrollView),
        const Offset(0, -50),
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    // Test 5: Password validation - passwords don't match shows error
    testWidgets('5. should show error when passwords do not match', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildSignUpPage());
      await tester.pumpAndSettle();

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

      await tester.enterText(fullNameField, 'John Doe');
      await tester.enterText(usernameField, 'johndoe');
      await tester.enterText(emailField, 'john@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'password456');

      await tester.dragUntilVisible(
        find.widgetWithText(ElevatedButton, 'Sign Up'),
        find.byType(SingleChildScrollView),
        const Offset(0, -50),
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    // Test 6: Full name field accepts input
    testWidgets('6. should accept full name input', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildSignUpPage());
      await tester.pumpAndSettle();

      final fullNameField = find.ancestor(
        of: find.text('Full Name'),
        matching: find.byType(TextFormField),
      );

      await tester.enterText(fullNameField, 'Shreejal Shrestha');
      await tester.pump();

      expect(find.text('Shreejal Shrestha'), findsOneWidget);
    });

    // Test 7: Username field accepts input
    testWidgets('7. should accept username input', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildSignUpPage());
      await tester.pumpAndSettle();

      final usernameField = find.ancestor(
        of: find.text('Username'),
        matching: find.byType(TextFormField),
      );

      await tester.enterText(usernameField, 'shreejal123');
      await tester.pump();

      expect(find.text('shreejal123'), findsOneWidget);
    });

    // Test 8: Email field accepts valid email
    testWidgets('8. should accept valid email input', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildSignUpPage());
      await tester.pumpAndSettle();

      final emailField = find.ancestor(
        of: find.text('Email'),
        matching: find.byType(TextFormField),
      );

      await tester.enterText(emailField, 'shreejal@example.com');
      await tester.pump();

      expect(find.text('shreejal@example.com'), findsOneWidget);
    });

    // Test 9: Page has 5 text fields
    testWidgets('9. should render exactly 5 input fields', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildSignUpPage());
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(5));
    });

    // Test 10: Login link is visible
    testWidgets('10. should display login link for existing users', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildSignUpPage());
      await tester.pumpAndSettle();

      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

  });
}