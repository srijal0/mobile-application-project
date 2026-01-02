
import 'package:fashion_store_trendora/features/auth/presentation/state/auth_state.dart';
import 'package:fashion_store_trendora/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashion_store_trendora/features/onboarding/presentation/pages/first_on_boarding_screen.dart';
import 'package:fashion_store_trendora/core/widgets/my_button.dart';
import 'package:fashion_store_trendora/core/widgets/my_input_form_field.dart';
import 'package:fashion_store_trendora/core/widgets/my_progress_bar.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      // Navigate to onboarding after successful validation
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FirstOnBoardingScreen(
            fullName: _fullNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            username: _emailController.text.trim().split("@").first,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(height: 30),
                          MyProgressBar(notProgressFlex: 7),

                          const SizedBox(height: 40),

                          const Text(
                            "Create New Account",
                            style: TextStyle(
                              fontSize: 32,
                              color: Color(0xFF38B120), // Trendora green
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Enter Username, Email and Password to create new account",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 40),

                          MyInputFormField(
                            controller: _fullNameController,
                            labelText: "Username",
                            icon: const Icon(Icons.person),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your username";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),

                          MyInputFormField(
                            controller: _emailController,
                            labelText: "Email",
                            inputType: TextInputType.emailAddress,
                            icon: const Icon(Icons.email),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              if (!value.contains("@")) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),

                          MyInputFormField(
                            controller: _passwordController,
                            labelText: "Password",
                            obscureText: true,
                            icon: const Icon(Icons.key),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your password";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),

                          MyInputFormField(
                            controller: _confirmPasswordController,
                            labelText: "Confirm Password",
                            obscureText: true,
                            icon: const Icon(Icons.key_off),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please confirm your password";
                              }
                              if (value != _passwordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: const [
                              Icon(
                                Icons.check_box,
                                color: Color(0xFFFFAE37), // Trendora yellow
                                size: 28,
                              ),
                              SizedBox(width: 10),
                              Text("Remember Me", style: TextStyle(fontSize: 15)),
                            ],
                          ),

                          const Spacer(),

                          MyButton(
                            text: authState.status == AuthStatus.loading
                                ? "Signing Up..."
                                : "Sign Up",
                            onPressed: authState.status == AuthStatus.loading
                                ? null
                                : _handleSignUp,
                          ),
                        ],
                      ),
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
