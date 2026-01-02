// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashion_store_trendora/app/app.dart';
import 'package:fashion_store_trendora/core/services/hive/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive before app starts
  await HiveService().init();

  // Wrap app in ProviderScope for Riverpod
  runApp(const ProviderScope(child: TrendoraApp()));
}
