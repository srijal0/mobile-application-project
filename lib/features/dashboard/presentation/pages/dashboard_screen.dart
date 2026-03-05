import 'package:fashion_store_trendora/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:fashion_store_trendora/features/dashboard/presentation/pages/bottom_screen/about_screen.dart';
import 'package:fashion_store_trendora/features/dashboard/presentation/pages/bottom_screen/cart_screen.dart';
import 'package:fashion_store_trendora/features/dashboard/presentation/pages/bottom_screen/home_screen.dart';
import 'package:fashion_store_trendora/features/dashboard/presentation/pages/bottom_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  Widget _currentScreen(String fullName, String username, String email) {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const CartScreen();
      case 2:
        // ✅ Uses actual logged-in user data
        return ProfileScreen(
          fullName: fullName,
          username: username,
          email: email,
          password: '',
        );
      case 3:
        return const AboutScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Use Consumer only around the body to read auth state
      body: Consumer(
        builder: (context, ref, _) {
          final authState = ref.watch(authViewModelProvider);
          final user = authState.entity;

          final fullName = user?.fullName ?? '';
          final username = user?.username ?? '';
          final email = user?.email ?? '';

          return _currentScreen(fullName, username, email);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
        backgroundColor: Colors.red,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: (index) {
          // ✅ Clears snackbars when switching tabs
          ScaffoldMessenger.of(context).clearSnackBars();
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}