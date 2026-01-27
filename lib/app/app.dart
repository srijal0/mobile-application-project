import 'package:fashion_store_trendora/core/services/storage/user_session.dart';
import 'package:fashion_store_trendora/features/auth/presentation/pages/login_screen.dart';
import 'package:fashion_store_trendora/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrendoraApp extends ConsumerWidget {
  const TrendoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if user has completed onboarding
    final sharedPrefs = ref.watch(sharedPreferenceProvider);
    final hasSeenOnboarding = sharedPrefs.getBool('has_seen_onboarding') ?? false;

    return MaterialApp(
      title: 'Trendora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
        fontFamily: 'OpenSansRegular',
      ),
      // Show onboarding if user hasn't seen it, otherwise show login
      home: hasSeenOnboarding ? const LoginPage() : const OnboardingScreen(),
    );
  }
}