// lib/features/splash/presentation/pages/splash_screen.dart
import 'dart:async';
import 'package:fashion_store_trendora/features/splash/presentation/pages/second_screen.dart';
import 'package:flutter/material.dart';
// Or directly: import 'package:fashion_store_trendora/features/auth/presentation/pages/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SecondScreen()),
          // Or: MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Trendora logo splash
              Image.asset(
                "assets/images/trendora_logo.png",
                height: MediaQuery.of(context).size.height * 0.6,
              ),
              Image.asset(
                "assets/images/trendora_title.png",
                height: 100,
              ),
              const Text(
                "Your Fashion, Your Identity",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF38B120), // Trendora green
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
