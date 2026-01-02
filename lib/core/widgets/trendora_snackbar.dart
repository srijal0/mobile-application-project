// lib/widgets/trendora_snackbar.dart
import 'package:flutter/material.dart';

void showTrendoraSnackBar({
  required BuildContext context,
  required String message,
  Color? color,
  int durationSeconds = 2,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color ?? const Color(0xFFDA1B2B), // Trendora red
      duration: Duration(seconds: durationSeconds),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
