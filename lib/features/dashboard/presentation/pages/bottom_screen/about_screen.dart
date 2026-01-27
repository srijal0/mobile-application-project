import 'package:fashion_store_trendora/core/utils/user_storage.dart';
import 'package:fashion_store_trendora/features/auth/presentation/pages/login_screen.dart';

import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  final String userName;

  const AboutScreen({super.key, required this.userName});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String selectedCountry = 'Nepal';
  bool isDarkMode = false;
  final TextEditingController feedbackController = TextEditingController();

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  void _chooseCountry() {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            'Select Country',
            style: TextStyle(fontSize: isTablet ? 22 : 18),
          ),
          children: [
            _countryOption('Australia', '🇦🇺', isTablet),
            _countryOption('Nepal', '🇳🇵', isTablet),
            _countryOption('UK', '🇬🇧', isTablet),
            _countryOption('USA', '🇺🇸', isTablet),
            _countryOption('Canada', '🇨🇦', isTablet),
            _countryOption('India', '🇮🇳', isTablet),
            _countryOption('Japan', '🇯🇵', isTablet),
            _countryOption('Germany', '🇩🇪', isTablet),
            _countryOption('France', '🇫🇷', isTablet),
            _countryOption('China', '🇨🇳', isTablet),
          ],
        );
      },
    );
  }

  SimpleDialogOption _countryOption(String country, String flag, bool isTablet) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() => selectedCountry = country);
        Navigator.pop(context);
      },
      child: Row(
        children: [
          Text(flag, style: TextStyle(fontSize: isTablet ? 28 : 22)),
          SizedBox(width: isTablet ? 12 : 8),
          Text(
            country,
            style: TextStyle(fontSize: isTablet ? 18 : 14),
          ),
        ],
      ),
    );
  }

  void _showAccountInfo() {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    final currentUser = UserStorage.getCurrentUser();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(
          isTablet ? 24 : 20,
          isTablet ? 24 : 20,
          isTablet ? 24 : 20,
          isTablet ? 16 : 12,
        ),
        title: Text(
          'Account Information',
          style: TextStyle(fontSize: isTablet ? 22 : 18),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                'Full Name: ${currentUser?.fullName ?? widget.userName}',
                style: TextStyle(fontSize: isTablet ? 18 : 14),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                'Username: ${currentUser?.username ?? 'N/A'}',
                style: TextStyle(fontSize: isTablet ? 18 : 14),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                'Email: ${currentUser?.email ?? 'N/A'}',
                style: TextStyle(fontSize: isTablet ? 18 : 14),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                'Membership: Premium',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(fontSize: isTablet ? 18 : 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showPolicies() {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Policies',
          style: TextStyle(fontSize: isTablet ? 22 : 18),
        ),
        content: Text(
          '1. Privacy Policy: Your data is safe and encrypted.\n\n'
          '2. Terms of Service: Use the app responsibly and ethically.\n\n'
          '3. Refund Policy: Orders can be refunded within 7 days of purchase.\n\n'
          '4. Data Protection: We comply with GDPR and data protection laws.',
          style: TextStyle(fontSize: isTablet ? 16 : 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(fontSize: isTablet ? 18 : 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Help & Support',
          style: TextStyle(fontSize: isTablet ? 22 : 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• To browse flowers, use the Home screen.',
              style: TextStyle(fontSize: isTablet ? 16 : 14),
            ),
            SizedBox(height: isTablet ? 8 : 4),
            Text(
              '• To place an order, add items to cart and checkout.',
              style: TextStyle(fontSize: isTablet ? 16 : 14),
            ),
            SizedBox(height: isTablet ? 8 : 4),
            Text(
              '• To edit your profile, go to Profile screen.',
              style: TextStyle(fontSize: isTablet ? 16 : 14),
            ),
            SizedBox(height: isTablet ? 8 : 4),
            Text(
              '• For any issues, contact: support@flowerblossom.com',
              style: TextStyle(fontSize: isTablet ? 16 : 14),
            ),
            SizedBox(height: isTablet ? 8 : 4),
            Text(
              '• Phone: +977-1-234567',
              style: TextStyle(fontSize: isTablet ? 16 : 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(fontSize: isTablet ? 18 : 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedback() {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Send Feedback',
          style: TextStyle(fontSize: isTablet ? 22 : 18),
        ),
        content: TextField(
          controller: feedbackController,
          maxLines: isTablet ? 6 : 4,
          style: TextStyle(fontSize: isTablet ? 16 : 14),
          decoration: InputDecoration(
            hintText: 'Enter your feedback here...',
            hintStyle: TextStyle(fontSize: isTablet ? 16 : 14),
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: isTablet ? 18 : 14),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final feedback = feedbackController.text.trim();
              if (feedback.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Thank you for your feedback!',
                      style: TextStyle(fontSize: isTablet ? 16 : 14),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                feedbackController.clear();
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Please enter some feedback',
                      style: TextStyle(fontSize: isTablet ? 16 : 14),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              'Submit',
              style: TextStyle(
                fontSize: isTablet ? 18 : 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutApp() {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'About Flower Blossom',
          style: TextStyle(fontSize: isTablet ? 22 : 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🌸 Flower Blossom',
              style: TextStyle(
                fontSize: isTablet ? 20 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: isTablet ? 16 : 14),
            ),
            SizedBox(height: isTablet ? 8 : 4),
            Text(
              'Your trusted flower delivery app in Nepal.',
              style: TextStyle(fontSize: isTablet ? 16 : 14),
            ),
            SizedBox(height: isTablet ? 8 : 4),
            Text(
              '\n© 2025 Flower Blossom. All rights reserved.',
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(fontSize: isTablet ? 18 : 14),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Logout',
          style: TextStyle(fontSize: isTablet ? 22 : 18),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: isTablet ? 16 : 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: isTablet ? 18 : 14),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Clear user data
              UserStorage.clearUser();
              
              // Navigate to login and remove all previous routes
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: isTablet ? 18 : 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'About',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFFCE4EC),
              child: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: isTablet ? 8 : 4,
                  horizontal: 0,
                ),
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.red,
                      size: isTablet ? 28 : 24,
                    ),
                    title: Text(
                      'Account Information',
                      style: TextStyle(
                        fontSize: isTablet ? 17 : 15,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: isTablet ? 20 : 16,
                      color: Colors.grey,
                    ),
                    onTap: _showAccountInfo,
                  ),
                  const Divider(height: 1, thickness: 0.5),

                  ListTile(
                    leading: Icon(
                      Icons.public,
                      color: Colors.red,
                      size: isTablet ? 28 : 24,
                    ),
                    title: Text(
                      'Country',
                      style: TextStyle(
                        fontSize: isTablet ? 17 : 15,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      selectedCountry,
                      style: TextStyle(
                        fontSize: isTablet ? 15 : 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: isTablet ? 20 : 16,
                      color: Colors.grey,
                    ),
                    onTap: _chooseCountry,
                  ),
                  const Divider(height: 1, thickness: 0.5),

                  ListTile(
                    leading: Icon(
                      Icons.dark_mode,
                      color: Colors.red,
                      size: isTablet ? 28 : 24,
                    ),
                    title: Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontSize: isTablet ? 17 : 15,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: Switch(
                      value: isDarkMode,
                      activeColor: Colors.red,
                      onChanged: (val) {
                        setState(() {
                          isDarkMode = val;
                        });
                      },
                    ),
                  ),
                  const Divider(height: 1, thickness: 0.5),

                  ListTile(
                    leading: Icon(
                      Icons.policy,
                      color: Colors.red,
                      size: isTablet ? 28 : 24,
                    ),
                    title: Text(
                      'Policies',
                      style: TextStyle(
                        fontSize: isTablet ? 17 : 15,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: isTablet ? 20 : 16,
                      color: Colors.grey,
                    ),
                    onTap: _showPolicies,
                  ),
                  const Divider(height: 1, thickness: 0.5),

                  ListTile(
                    leading: Icon(
                      Icons.help,
                      color: Colors.red,
                      size: isTablet ? 28 : 24,
                    ),
                    title: Text(
                      'Help & Support',
                      style: TextStyle(
                        fontSize: isTablet ? 17 : 15,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: isTablet ? 20 : 16,
                      color: Colors.grey,
                    ),
                    onTap: _showHelp,
                  ),
                  const Divider(height: 1, thickness: 0.5),

                  ListTile(
                    leading: Icon(
                      Icons.feedback,
                      color: Colors.red,
                      size: isTablet ? 28 : 24,
                    ),
                    title: Text(
                      'Send Feedback',
                      style: TextStyle(
                        fontSize: isTablet ? 17 : 15,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: isTablet ? 20 : 16,
                      color: Colors.grey,
                    ),
                    onTap: _showFeedback,
                  ),
                  const Divider(height: 1, thickness: 0.5),

                  ListTile(
                    leading: Icon(
                      Icons.info,
                      color: Colors.red,
                      size: isTablet ? 28 : 24,
                    ),
                    title: Text(
                      'About App',
                      style: TextStyle(
                        fontSize: isTablet ? 17 : 15,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: isTablet ? 20 : 16,
                      color: Colors.grey,
                    ),
                    onTap: _showAboutApp,
                  ),
                  const Divider(height: 1, thickness: 0.5),
                ],
              ),
            ),
          ),

          // Logout Button
          Container(
            color: const Color(0xFFFCE4EC),
            padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
            child: ElevatedButton.icon(
              onPressed: _confirmLogout,
              icon: Icon(
                Icons.logout,
                size: isTablet ? 22 : 18,
                color: Colors.white,
              ),
              label: Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: isTablet ? 17 : 15,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(
                  double.infinity,
                  isTablet ? 56 : 48,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}