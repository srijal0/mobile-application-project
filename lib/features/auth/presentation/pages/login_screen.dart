// lib/features/auth/presentation/pages/login_screen.dart
import 'package:fashion_store_trendora/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:fashion_store_trendora/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashion_store_trendora/common/my_snack_bar.dart';
import 'package:fashion_store_trendora/features/auth/presentation/state/auth_state.dart';
import 'package:fashion_store_trendora/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:fashion_store_trendora/core/widgets/my_button.dart';
import 'package:fashion_store_trendora/core/widgets/my_input_form_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      ref.read(authViewModelProvider.notifier).login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        showMySnackBar(
          context: context,
          message: next.errorMessage ?? "Login Failed",
          color: Colors.redAccent,
        );
      } else if (next.status == AuthStatus.authenticated) {
        showMySnackBar(
          context: context,
          message: "Login Successful",
          color: Colors.green.shade900,
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 🔥 Branding header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 35,
                        color: Color(0xFF38B120), // Trendora green
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Please fill up email and password to log in to your account",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // 🔑 Input fields
                Column(
                  children: [
                    MyInputFormField(
                      controller: _emailController,
                      labelText: "Email",
                      inputType: TextInputType.emailAddress,
                      icon: const Icon(Icons.email),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
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
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_box,
                          color: Color(0xFFFFAE37), // Trendora yellow
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        const Text("Remember Me", style: TextStyle(fontSize: 15)),
                        const Spacer(),
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // 🚀 Actions
                Column(
                  children: [
                    MyButton(
                      text: authState.status == AuthStatus.loading
                          ? "Logging in..."
                          : "Login",
                      onPressed: authState.status == AuthStatus.loading
                          ? null
                          : _handleLogin,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFFFFAE37), // Trendora yellow
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
