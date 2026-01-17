import 'package:fashion_store_trendora/app/routes/app_route.dart';
import 'package:fashion_store_trendora/common/my_snack_bar.dart';
import 'package:fashion_store_trendora/core/utils/snack_bar_utils.dart';
import 'package:fashion_store_trendora/features/auth/presentation/pages/login_screen.dart';
import 'package:fashion_store_trendora/features/auth/presentation/state/auth_state.dart';
import 'package:fashion_store_trendora/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:fashion_store_trendora/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String selectedCountryCode = '+977';
  String? selectedCity;

  final cities = ['Kathmandu', 'Pokhara', 'Lalitpur', 'Bhaktapur'];

  final countryCodes = [
    {'code': '+977', 'flag': '🇳🇵'},
    {'code': '+91', 'flag': '🇮🇳'},
    {'code': '+1', 'flag': '🇺🇸'},
    {'code': '+44', 'flag': '🇬🇧'},
  ];

  // =====================================================
  // ✅ THIS IS THE FUNCTION YOU ASKED TO KEEP
  // =====================================================
  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      ref.read(authViewModelProvider.notifier).register(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        username: emailController.text.split('@').first,
        phoneNumber:
            '$selectedCountryCode${phoneController.text.trim()}',
        address: selectedCity,
      );
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ CRITICAL FIX: This triggers the ViewModel's build() method and initializes all use cases
    ref.watch(authViewModelProvider);
    
    // ✅ Listen Auth State
   ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        showMySnackBar(
          context: context,
          message: next.errorMessage ?? "Registration failed",
        );
      } else if (next.status == AuthStatus.registered) {
        showMySnackBar(context: context, message: "Registration successful");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 260,
            decoration: const BoxDecoration(
              color: Color(0xFFD32F2F),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _input("Full Name", fullNameController),
                            const SizedBox(height: 14),

                            Row(
                              children: [
                                SizedBox(
                                  width: 110,
                                  child: DropdownButtonFormField<String>(
                                    value: selectedCountryCode,
                                    decoration: const InputDecoration(
                                        labelText: "Code"),
                                    items: countryCodes.map((c) {
                                      return DropdownMenuItem(
                                        value: c['code'],
                                        child:
                                            Text("${c['flag']} ${c['code']}"),
                                      );
                                    }).toList(),
                                    onChanged: (v) =>
                                        setState(() => selectedCountryCode = v!),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _input(
                                      "Phone Number", phoneController),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            DropdownButtonFormField<String>(
                              value: selectedCity,
                              decoration: const InputDecoration(
                                  labelText: "Delivery City"),
                              items: cities
                                  .map((city) => DropdownMenuItem(
                                        value: city,
                                        child: Text(city),
                                      ))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => selectedCity = v),
                              validator: (v) =>
                                  v == null ? 'Select a city' : null,
                            ),

                            const SizedBox(height: 14),
                            _input("Email", emailController),
                            const SizedBox(height: 14),
                            _input("Password", passwordController,
                                obscure: true),
                            const SizedBox(height: 14),
                            _input(
                              "Confirm Password",
                              confirmPasswordController,
                              obscure: true,
                              validator: (v) =>
                                  v != passwordController.text
                                      ? 'Passwords do not match'
                                      : null,
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _handleSignup, // ✅ IMPLEMENTED
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                       Color(0xFFD32F2F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Already have an account? "),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const LoginPage()),
                                  ),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Color(0xFFD32F2F),
                                      fontWeight: FontWeight.bold,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(
    String hint,
    TextEditingController controller, {
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator:
          validator ?? (v) => v == null || v.isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}