import 'package:fashion_store_trendora/screens/bottom_screen/about_screen.dart';
import 'package:fashion_store_trendora/screens/bottom_screen/cart_screen.dart';
import 'package:fashion_store_trendora/screens/bottom_screen/home_screen.dart';
import 'package:fashion_store_trendora/screens/bottom_screen/profile_screen.dart';
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
    const ProfileScreen(),
    const AboutScreen(),
  ]; //  <-- Missing semicolon FIXED!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     

      body: lstBottomScreen[_selectedIndex], // <-- Shows the correct page

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