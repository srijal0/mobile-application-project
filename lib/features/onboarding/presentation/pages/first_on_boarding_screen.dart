// lib/features/onboarding/presentation/pages/first_on_boarding_screen.dart
import 'package:flutter/material.dart';
import 'package:fashion_store_trendora/features/onboarding/presentation/pages/second_on_boarding_screen.dart';
import 'package:fashion_store_trendora/core/widgets/my_button.dart';
import 'package:fashion_store_trendora/core/widgets/my_progress_bar.dart';

class FirstOnBoardingScreen extends StatefulWidget {
  final String fullName;
  final String email;
  final String password;
  final String username;

  const FirstOnBoardingScreen({
    super.key,
    required this.fullName,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<FirstOnBoardingScreen> createState() => _FirstOnBoardingScreenState();
}

class _FirstOnBoardingScreenState extends State<FirstOnBoardingScreen> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              MyProgressBar(notProgressFlex: 3),
              const SizedBox(height: 50),

              const Text(
                "Select your gender",
                style: TextStyle(
                  fontSize: 32,
                  color: Color(0xFF38B120), // Trendora green
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              // 🔥 Gender options
              RadioListTile<String>(
                activeColor: const Color(0xFFFFAE37), // Trendora yellow
                title: const Text("Male", style: TextStyle(fontSize: 22)),
                value: "Male",
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() => _selectedGender = value);
                },
              ),
              RadioListTile<String>(
                activeColor: const Color(0xFFFFAE37),
                title: const Text("Female", style: TextStyle(fontSize: 22)),
                value: "Female",
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() => _selectedGender = value);
                },
              ),
              RadioListTile<String>(
                activeColor: const Color(0xFFFFAE37),
                title: const Text("Others", style: TextStyle(fontSize: 22)),
                value: "Others",
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() => _selectedGender = value);
                },
              ),

              const Spacer(),

              MyButton(
                text: "Continue",
                onPressed: () {
                  if (_selectedGender == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a gender to continue"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondOnBoardingScreen(
                        fullName: widget.fullName,
                        email: widget.email,
                        password: widget.password,
                        username: widget.username,
                        gender: _selectedGender!, // ✅ pass selected gender
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
