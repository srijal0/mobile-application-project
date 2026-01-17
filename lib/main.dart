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

  // ✅ Initialize Hive Service
  print("📦 Initializing Hive...");
  final hiveService = HiveService();
  await hiveService.init();
  print("✅ Hive initialized successfully!");

  // ✅ Initialize SharedPreferences
  print("📦 Initializing SharedPreferences...");
  final sharedPreferences = await SharedPreferences.getInstance();
  print("✅ SharedPreferences initialized successfully!");

  // 🔴 FORCE SYSTEM UI CHANGE
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.red,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.red,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        // Override the sharedPreferenceProvider with the actual instance
        sharedPreferenceProvider.overrideWithValue(sharedPreferences),
      ],
      child: const TrendoraApp(),
    ),
  );
}