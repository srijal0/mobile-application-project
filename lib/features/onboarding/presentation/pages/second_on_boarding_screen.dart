// lib/features/onboarding/presentation/pages/second_on_boarding_screen.dart
//onboarding code
import 'package:flutter/material.dart';
import 'package:fashion_store_trendora/features/onboarding/presentation/pages/final_on_boarding_screen.dart';
import 'package:fashion_store_trendora/core/widgets/my_button.dart';
import 'package:fashion_store_trendora/core/widgets/my_progress_bar.dart';

class SecondOnBoardingScreen extends StatefulWidget {
  final String fullName;
  final String email;
  final String password;
  final String username;
  final String gender; // ✅ passed from FirstOnBoardingScreen

  const SecondOnBoardingScreen({
    super.key,
    required this.fullName,
    required this.email,
    required this.password,
    required this.username,
    required this.gender,
  });

  @override
  State<SecondOnBoardingScreen> createState() => _SecondOnBoardingScreenState();
}

class _SecondOnBoardingScreenState extends State<SecondOnBoardingScreen> {
  String? _selectedAge;

  final List<String> _lstAge = [
    "14-17",
    "18-24",
    "25-29",
    "30-34",
    "35-39",
    "40-44",
    "45-49",
    "50+",
  ];

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
              MyProgressBar(notProgressFlex: 1),
              const SizedBox(height: 50),

              const Text(
                "Select your Age",
                style: TextStyle(
                  fontSize: 32,
                  color: Color(0xFF38B120), // Trendora green
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              Expanded(
                child: ListView.separated(
                  itemCount: _lstAge.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final age = _lstAge[index];
                    return RadioListTile<String>(
                      activeColor: const Color(0xFFFFAE37), // Trendora yellow
                      title: Text(age, style: const TextStyle(fontSize: 20)),
                      value: age,
                      groupValue: _selectedAge,
                      onChanged: (value) {
                        setState(() => _selectedAge = value);
                      },
                    );
                  },
                ),
              ),

              MyButton(
                text: "Continue",
                onPressed: () {
                  if (_selectedAge == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select an age group to continue"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinalOnBoardingScreen(
                        fullName: widget.fullName,
                        email: widget.email,
                        password: widget.password,
                        username: widget.username,
                        // ✅ pass gender + age forward
                        // you can extend FinalOnBoardingScreen to accept these
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
