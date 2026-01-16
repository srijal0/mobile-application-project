import 'package:fashion_store_trendora/app/routes/app_route.dart';
import 'package:fashion_store_trendora/core/utils/snack_bar_utils.dart';
import 'package:fashion_store_trendora/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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

  // ✅ Save signup info locally
  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_email', emailController.text.trim());
      await prefs.setString('saved_password', passwordController.text);

      SnackbarUtils.showSuccess(context, "Account created successfully!");
      AppRoutes.pushReplacement(context, const LoginPage());
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
                                    items: countryCodes.map((c) {
                                      return DropdownMenuItem(
                                        value: c['code'],
                                        child: Text("${c['flag']} ${c['code']}"),
                                      );
                                    }).toList(),
                                    onChanged: (v) {
                                      setState(() {
                                        selectedCountryCode = v!;
                                      });
                                    },
                                    decoration:
                                        const InputDecoration(labelText: "Code"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _input("Phone Number", phoneController),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              value: selectedCity,
                              decoration: const InputDecoration(
                                labelText: "Delivery City",
                              ),
                              items: cities
                                  .map(
                                    (city) => DropdownMenuItem(
                                      value: city,
                                      child: Text(city),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                setState(() {
                                  selectedCity = v;
                                });
                              },
                              validator: (v) =>
                                  v == null ? 'Select a city' : null,
                            ),
                            const SizedBox(height: 14),
                            _input("Email", emailController),
                            const SizedBox(height: 14),
                            _input("Password", passwordController, obscure: true),
                            const SizedBox(height: 14),
                            _input(
                              "Confirm Password",
                              confirmPasswordController,
                              obscure: true,
                              validator: (v) => v != passwordController.text
                                  ? 'Passwords do not match'
                                  : null,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2E7D32),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: _handleSignup,
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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const LoginPage()),
                                    );
                                  },
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
      validator: validator ?? (v) => v == null || v.isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
