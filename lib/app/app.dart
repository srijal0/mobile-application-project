// import 'package:fashion_store_trendora/screens/dashboard_screen.dart';
// import 'package:fashion_store_trendora/screens/login_screen.dart';
// import 'package:fashion_store_trendora/screens/onboarding_screen.dart';
// import 'package:fashion_store_trendora/screens/signup_screen.dart';
// import 'package:fashion_store_trendora/screens/splash_screen.dart';
// import 'package:flutter/material.dart';



// class TrendoraApp extends StatelessWidget {
//   const TrendoraApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
     
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/',
//       routes: {
//         '/': (context) => SplashScreen(),
//         '/onboarding': (context) => OnboardingScreen(),
//         '/signup': (context) => SignupScreen(),
//         '/login': (context) => LoginScreen(),
//         '/dashboard': (context) => DashboardScreen(),
//       },
//     );
//   }
// }

// lib/app/app.dart
import 'package:fashion_store_trendora/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:fashion_store_trendora/app/themes/theme_data.dart';
import 'package:fashion_store_trendora/screens/splash_screen.dart';
import 'package:fashion_store_trendora/features/auth/presentation/pages/login_screen.dart';
import 'package:fashion_store_trendora/features/dashboard/presentation/pages/dashboard_screen.dart';

class TrendoraApp extends StatelessWidget {
  const TrendoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getTrendoraTheme(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}

