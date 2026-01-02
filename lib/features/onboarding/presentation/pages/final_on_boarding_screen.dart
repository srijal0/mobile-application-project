// lib/features/onboarding/presentation/pages/final_on_boarding_screen.dart
import 'package:fashion_store_trendora/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashion_store_trendora/common/my_snack_bar.dart';
import 'package:fashion_store_trendora/features/auth/presentation/state/auth_state.dart';
import 'package:fashion_store_trendora/core/widgets/my_button.dart';
import 'package:fashion_store_trendora/core/widgets/my_progress_bar.dart';
import 'package:fashion_store_trendora/features/dashboard/presentation/pages/dashboard_screen.dart';

class FinalOnBoardingScreen extends ConsumerStatefulWidget {
  final String fullName;
  final String email;
  final String password;
  final String username;

  const FinalOnBoardingScreen({
    super.key,
    required this.fullName,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  ConsumerState<FinalOnBoardingScreen> createState() =>
      _FinalOnBoardingScreenState();
}

class _FinalOnBoardingScreenState extends ConsumerState<FinalOnBoardingScreen> {
  Future<void> _handleSignup() async {
    ref.read(authViewModelProvider.notifier).register(
          fullName: widget.fullName,
          email: widget.email,
          password: widget.password,
          username: widget.username,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        showMySnackBar(
          context: context,
          message: next.errorMessage ?? "Registration failed",
          color: Colors.redAccent,
        );
      } else if (next.status == AuthStatus.registering) {
        showMySnackBar(
          context: context,
          message: "Registration successful",
          color: Colors.green.shade900,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    });

    // Trendora categories instead of book genres
    List<String> fashionCategories = [
      "Casual Wear",
      "Formal Wear",
      "Street Style",
      "Ethnic",
      "Sportswear",
      "Accessories",
      "Shoes",
      "Bags",
      "Winter Collection",
      "Summer Collection",
    ];

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        MyProgressBar(notProgressFlex: 0),
                        const SizedBox(height: 50),
                        const Text(
                          "Choose Your Fashion Interests",
                          style: TextStyle(
                            fontSize: 32,
                            color: Color(0xFF38B120), // Trendora green
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),

                        Wrap(
                          spacing: 13,
                          runSpacing: 20,
                          children: fashionCategories
                              .map(
                                (category) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 25,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFFFAE37), // Trendora yellow
                                      width: 2,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    category,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                        const Spacer(),

                        MyButton(text: "Continue", onPressed: _handleSignup),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
