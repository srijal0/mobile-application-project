// lib/features/profile/presentation/pages/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF38B120), // Trendora green
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF38B120)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 👤 Profile avatar
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/profile_placeholder.png"),
              ),
              const SizedBox(height: 15),
              const Text(
                "Shreejal Shrestha",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "shreejal@example.com",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 30),

              // ⚙️ Profile options
              ListTile(
                leading: const Icon(Icons.shopping_bag, color: Color(0xFFFFAE37)),
                title: const Text("My Orders"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to orders screen
                },
              ),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.favorite, color: Colors.redAccent),
                title: const Text("Wishlist"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to wishlist screen
                },
              ),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.settings, color: Colors.blueAccent),
                title: const Text("Settings"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to settings screen
                },
              ),
              const Divider(),

              const Spacer(),

              // 🚪 Logout button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38B120), // Trendora green
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: Call authViewModelProvider.logout()
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
