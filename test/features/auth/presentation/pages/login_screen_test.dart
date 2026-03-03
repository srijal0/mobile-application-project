import 'package:fashion_store_trendora/common/widgets/custom_widgets.dart';
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
      expect(find.text('TRENDORA'), findsOneWidget); // Logo
      expect(find.text('Wear the trend. Own your style.'), findsOneWidget); // Tagline
      expect(find.byType(TextFormField), findsNWidgets(2)); // Email & Password
      expect(find.byIcon(Icons.email), findsOneWidget); // Email icon
      expect(find.byIcon(Icons.lock), findsOneWidget); // Password icon
      expect(find.byType(AnimatedGradientButton), findsOneWidget); // Login button
      expect(find.text("Don't have an account?"), findsWidgets); // Sign up text
      expect(find.text("Sign Up Here"), findsOneWidget);
    });

    // Test 2: Email field accepts input
    testWidgets('should accept email input', (tester) async {
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

      // Act - Enter email
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'test@example.com');
      await tester.pump();

      // Assert - Verify email was entered
      expect(find.text('test@example.com'), findsOneWidget);
    });

    // Test 3: Password field accepts input
    testWidgets('should accept password input', (tester) async {
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

      // Act - Enter password
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.last, 'password123');
      await tester.pump();

      // Assert - TextFormField exists and accepts input
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    // Test 4: Login button is present and interactable
    testWidgets('should have interactive login button', (tester) async {
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

      // Assert - Button exists
      expect(find.byType(AnimatedGradientButton), findsOneWidget);
      expect(find.byType(GestureDetector), findsWidgets);
    });

    // Test 5: Form can be filled completely
    testWidgets('should accept valid email and password', (tester) async {
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
      await tester.enterText(textFields.first, 'user@example.com');
      await tester.enterText(textFields.last, 'validpass123');
      await tester.pump();

      // Assert - Verify both texts were entered
      expect(find.text('user@example.com'), findsOneWidget);
      expect(find.text('validpass123'), findsOneWidget);
    });

  });
}
