import 'package:fashion_store_trendora/core/services/storage/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashion_store_trendora/app/app.dart';
import 'package:fashion_store_trendora/core/services/hive/hive_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 LOG TO CONFIRM APP RESTART
  print("🔥 TRENDORA APP STARTED 🔥");

  try {
    // ✅ Initialize Hive Service
    print("📦 Initializing Hive...");
    final hiveService = HiveService();
    await hiveService.init();
    print("✅ Hive initialized successfully!");

    // ✅ Initialize SharedPreferences
    print("📦 Initializing SharedPreferences...");
    final sharedPreferences = await SharedPreferences.getInstance();
    print("✅ SharedPreferences initialized successfully!");

    // 🔴 Set System UI Style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // 🔄 Set preferred orientations (optional - remove if you want landscape support)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    print("✅ All services initialized. Starting app...");

    runApp(
      ProviderScope(
        overrides: [
          // Override the sharedPreferenceProvider with the actual instance
          sharedPreferenceProvider.overrideWithValue(sharedPreferences),
        ],
        child: const TrendoraApp(),
      ),
    );
  } catch (e, stackTrace) {
    // ❌ Catch any initialization errors
    print("❌ FATAL ERROR during app initialization:");
    print("Error: $e");
    print("StackTrace: $stackTrace");
    
    // You could show an error screen here or rethrow
    rethrow;
  }
}