import 'screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

class TrendoraApp extends StatelessWidget {
  const TrendoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BODH',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}