import 'package:flutter/material.dart';

class AppRoutes {
  static void pushReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static void push(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
