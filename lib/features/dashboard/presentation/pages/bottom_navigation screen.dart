// lib/features/dashboard/presentation/pages/bottom_navigation_screen.dart
import 'package:flutter/material.dart';
import 'package:fashion_store_trendora/features/dashboard/presentation/pages/bottom_screen/explore_screen.dart';
import 'package:fashion_store_trendora/features/dashboard/presentation/pages/bottom_screen/home_screen.dart';
import 'package:fashion_store_trendora/features/dashboard/presentation/pages/bottom_screen/profile_screen.dart';
import 'package:fashion_store_trendora/features/dashboard/presentation/pages/bottom_screen/wishlist_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    WishlistScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF38B120), // Trendora green
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
