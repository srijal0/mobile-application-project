// lib/features/onboarding/presentation/pages/second_screen.dart
import 'package:flutter/material.dart';
import 'package:fashion_store_trendora/core/widgets/my_button.dart';
import 'package:fashion_store_trendora/features/auth/presentation/pages/login_screen.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 🔥 Trendora fashion image instead of book stack
            Image.asset("assets/images/fashion_intro.jpg", height: 400),

            const Text(
              "Discover your style with Trendora",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF38B120), // Trendora green
              ),
              textAlign: TextAlign.center,
            ),

            const Text(
              "Shop the latest fashion trends curated just for you.",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),

            MyButton(
              text: "Continue",
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
