import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashion_store_trendora/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 LOG TO CONFIRM APP RESTART
  print("🔥 TRENDORA APP STARTED 🔥");

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
    const ProviderScope(
      child: TrendoraApp(),
    ),
  );
}
