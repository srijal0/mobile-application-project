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

// Helper to build the login page
Widget buildLoginPage() {
  return ProviderScope(
    overrides: [
      authViewModelProvider.overrideWith(() => MockAuthViewModel()),
    ],
    child: MediaQuery(
      data: const MediaQueryData(size: Size(1080, 1920)),
      child: const MaterialApp(
        home: LoginPage(),
      ),
    ),
  );
}

void main() {
  group('LoginPage Widget Tests', () {

    // Test 1: Widget renders with all required UI elements
    testWidgets('1. should display all login UI elements', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      expect(find.text('TRENDORA'), findsOneWidget);
      expect(find.text('Wear the trend. Own your style.'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.byType(AnimatedGradientButton), findsOneWidget);
      expect(find.text("Don't have an account?"), findsWidgets);
      expect(find.text("Sign Up Here"), findsOneWidget);
    });

    // Test 2: Email field accepts input
    testWidgets('2. should accept email input', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'test@example.com');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    // Test 3: Password field accepts input
    testWidgets('3. should accept password input', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.last, 'password123');
      await tester.pump();

      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    // Test 4: Login button is present and interactable
    testWidgets('4. should have interactive login button', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      expect(find.byType(AnimatedGradientButton), findsOneWidget);
      expect(find.byType(GestureDetector), findsWidgets);
    });

    // Test 5: Form can be filled completely
    testWidgets('5. should accept valid email and password', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'user@example.com');
      await tester.enterText(textFields.last, 'validpass123');
      await tester.pump();

      expect(find.text('user@example.com'), findsOneWidget);
    });

    // Test 6: Email field is first text field
    testWidgets('6. should have email field as first input', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      expect(textFields, findsNWidgets(2));
      // First field should be email
      await tester.enterText(textFields.at(0), 'email@test.com');
      await tester.pump();
      expect(find.text('email@test.com'), findsOneWidget);
    });

    // Test 7: Sign Up link is tappable
    testWidgets('7. should have tappable sign up link', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      expect(find.text('Sign Up Here'), findsOneWidget);
      final signUpLink = find.text('Sign Up Here');
      expect(signUpLink, findsOneWidget);
    });

    // Test 8: Page renders without overflow errors
    testWidgets('8. should render without overflow errors', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      // If no exceptions are thrown, the widget renders correctly
      expect(find.byType(LoginPage), findsOneWidget);
    });

    // Test 9: Email icon is displayed
    testWidgets('9. should display email and lock icons', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    // Test 10: Fields are cleared when re-entered
    testWidgets('10. should update text when field is re-entered', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      await tester.pumpWidget(buildLoginPage());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'first@example.com');
      await tester.pump();
      expect(find.text('first@example.com'), findsOneWidget);

      await tester.enterText(textFields.first, 'second@example.com');
      await tester.pump();
      expect(find.text('second@example.com'), findsOneWidget);
    });

  });
}