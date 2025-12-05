import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trendora"),
        backgroundColor: Colors.amber,
      ),
      body: const Center(
        child: Text(
          "Welcome to Trendora!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
