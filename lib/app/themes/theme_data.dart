import 'package:flutter/material.dart';

ThemeData getTrendoraTheme() {
  return ThemeData(
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 25, fontFamily: "Bricolage"),
      displayMedium: TextStyle(fontSize: 18, fontFamily: "Bricolage"),
    ),

    scaffoldBackgroundColor: const Color(0xFFF9F9F9), // light neutral background
    fontFamily: "Bricolage",

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFFDA1B2B), // Trendora red
      unselectedItemColor: Color.fromARGB(255, 110, 110, 110),
      selectedIconTheme: IconThemeData(size: 30),
      selectedLabelStyle: TextStyle(fontSize: 18),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFDA1B2B), // Trendora red
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFDA1B2B)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFDA1B2B), width: 2),
      ),
      labelStyle: TextStyle(color: Color(0xFFDA1B2B)),
    ),
  );
}
