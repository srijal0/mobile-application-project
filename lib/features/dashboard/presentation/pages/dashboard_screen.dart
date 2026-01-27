import 'package:fashion_store_trendora/features/dashboard/presentation/pages/bottom_screen/about_screen.dart';
import 'package:fashion_store_trendora/features/dashboard/presentation/pages/bottom_screen/cart_screen.dart';
import 'package:fashion_store_trendora/features/dashboard/presentation/pages/bottom_screen/home_screen.dart';
import 'package:fashion_store_trendora/features/dashboard/presentation/pages/bottom_screen/profile_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  List<Widget> lstBottomScreen = [
    const HomeScreen(),
    const CartScreen(),
    //  FIXED: Added required parameters for ProfileScreen
    const ProfileScreen(
      fullName: 'Shreejal Shrestha',        // Replace with actual user data
      username: 'shreejal',          // Replace with actual user data
      email: 'shreejal@example.com',    // Replace with actual user data
      password: 'shreejal123',      // Replace with actual user data
    ),
    // FIXED: Added required userName parameter for AboutScreen
    const AboutScreen(
      userName: 'Shreejal Shrestha',  // Replace with actual user data
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: lstBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
        backgroundColor: Colors.red,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}