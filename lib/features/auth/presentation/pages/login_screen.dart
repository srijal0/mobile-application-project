import 'package:fashion_store_trendora/app/routes/app_route.dart';
import 'package:fashion_store_trendora/common/widgets/custom_widgets.dart';
import 'package:fashion_store_trendora/core/sensors/shake_sensor_service.dart';
import 'package:fashion_store_trendora/core/utils/snack_bar_utils.dart';
import 'package:fashion_store_trendora/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:fashion_store_trendora/features/auth/presentation/state/auth_state.dart';
import 'package:fashion_store_trendora/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:fashion_store_trendora/features/dashboard/presentation/pages/dashboard_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _showShakeError = false;

  @override
  void initState() {
    super.initState();
    _initializeShakeSensor();
  }

  /// Initialize shake sensor to detect shake gesture
  void _initializeShakeSensor() {
    try {
      ShakeSensorService.detectShake().listen(
        (_) {
          // Shake detected - auto-refresh login
          print('🤝 Shake detected!');
          if (emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty) {
            _handleLogin();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter email and password to login'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        },
        onError: (e) {
          print('Shake sensor error: $e');
        },
      );
    } catch (e) {
      print('Could not initialize shake sensor: $e');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authViewModelProvider.notifier).login(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
    }
  }

  void _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        AppRoutes.pushReplacement(context, const DashboardScreen());
      } else if (next.status == AuthStatus.error &&
          next.errorMessage != null) {
        setState(() => _showShakeError = true);
        Future.delayed(const Duration(milliseconds: 500),
            () => setState(() => _showShakeError = false));
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 🔴 Header with Fade Animation
              SlideInFromBottom(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 180, bottom: 40),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFD32F2F), Color(0xFF1565C0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        "TRENDORA",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Wear the trend. Own your style.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Title with Fade Animation
              FadeInText(
                "Login to your account",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 30),

              // 📧 Email with Shake Animation
              ShakeAnimation(
                show: _showShakeError,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SlideInFromBottom(
                    duration: const Duration(milliseconds: 700),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: const Icon(Icons.email,
                            color: Color(0xFFD32F2F)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xFFD32F2F),
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // 🔒 Password with Shake Animation
              ShakeAnimation(
                show: _showShakeError,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SlideInFromBottom(
                    duration: const Duration(milliseconds: 800),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon:
                            const Icon(Icons.lock, color: Color(0xFFD32F2F)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xFFD32F2F),
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Minimum 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 🎯 Custom Animated Gradient Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SlideInFromBottom(
                  duration: const Duration(milliseconds: 900),
                  child: AnimatedGradientButton(
                    label: authState.status == AuthStatus.loading
                        ? "LOGGING IN..."
                        : "LOGIN",
                    onPressed: authState.status == AuthStatus.loading
                        ? () {}
                        : _handleLogin,
                    isLoading: authState.status == AuthStatus.loading,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD32F2F), Color(0xFF1565C0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ➕ Sign up with Fade Animation
              FadeInText(
                "Don't have an account?",
                duration: const Duration(milliseconds: 1000),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _navigateToSignup,
                child: FadeInText(
                  "Sign Up Here",
                  duration: const Duration(milliseconds: 1100),
                  style: const TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
