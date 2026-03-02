import 'package:fashion_store_trendora/features/auth/presentation/pages/login_screen.dart';
import 'package:fashion_store_trendora/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
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

  SimpleDialogOption _countryOption(
      String country, String flag, bool isTablet) {
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
    final authState = ref.read(authViewModelProvider);
    final entity = authState.entity;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
                'Full Name: ${entity?.fullName ?? 'N/A'}',
                style: TextStyle(fontSize: isTablet ? 18 : 14),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                'Username: ${entity?.username ?? 'N/A'}',
                style: TextStyle(fontSize: isTablet ? 18 : 14),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                'Email: ${entity?.email ?? 'N/A'}',
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
            Text('• To browse products, use the Home screen.',
                style: TextStyle(fontSize: isTablet ? 16 : 14)),
            SizedBox(height: isTablet ? 8 : 4),
            Text('• To place an order, add items to cart and checkout.',
                style: TextStyle(fontSize: isTablet ? 16 : 14)),
            SizedBox(height: isTablet ? 8 : 4),
            Text('• To edit your profile, go to Profile screen.',
                style: TextStyle(fontSize: isTablet ? 16 : 14)),
            SizedBox(height: isTablet ? 8 : 4),
            Text('• For any issues, contact: support@trendora.com',
                style: TextStyle(fontSize: isTablet ? 16 : 14)),
            SizedBox(height: isTablet ? 8 : 4),
            Text('• Phone: +977-1-234567',
                style: TextStyle(fontSize: isTablet ? 16 : 14)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close',
                style: TextStyle(fontSize: isTablet ? 18 : 14)),
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
        title: Text('Send Feedback',
            style: TextStyle(fontSize: isTablet ? 22 : 18)),
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
            child: Text('Cancel',
                style: TextStyle(fontSize: isTablet ? 18 : 14)),
          ),
          ElevatedButton(
            onPressed: () {
              final feedback = feedbackController.text.trim();
              if (feedback.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Thank you for your feedback!',
                        style: TextStyle(fontSize: isTablet ? 16 : 14)),
                    backgroundColor: Colors.green,
                  ),
                );
                feedbackController.clear();
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter some feedback',
                        style: TextStyle(fontSize: isTablet ? 16 : 14)),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Submit',
                style: TextStyle(
                    fontSize: isTablet ? 18 : 14, color: Colors.white)),
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
        title: Text('About Trendora',
            style: TextStyle(fontSize: isTablet ? 22 : 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('👗 Trendora – Fashion Store',
                style: TextStyle(
                    fontSize: isTablet ? 20 : 16,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: isTablet ? 12 : 8),
            Text('Version: 1.0.0',
                style: TextStyle(fontSize: isTablet ? 16 : 14)),
            SizedBox(height: isTablet ? 8 : 4),
            Text('Your trusted fashion shopping app.',
                style: TextStyle(fontSize: isTablet ? 16 : 14)),
            SizedBox(height: isTablet ? 8 : 4),
            Text('\n© 2025 Trendora. All rights reserved.',
                style: TextStyle(
                    fontSize: isTablet ? 14 : 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close',
                style: TextStyle(fontSize: isTablet ? 18 : 14)),
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
        title: Text('Logout',
            style: TextStyle(fontSize: isTablet ? 22 : 18)),
        content: Text('Are you sure you want to logout?',
            style: TextStyle(fontSize: isTablet ? 16 : 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(fontSize: isTablet ? 18 : 14)),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(authViewModelProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Logout',
                style: TextStyle(
                    fontSize: isTablet ? 18 : 14, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    // Dark mode colors
    final bgColor = isDarkMode ? Colors.grey[900]! : const Color(0xFFFCE4EC);
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final dividerColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final iconColor = isDarkMode ? Colors.redAccent : Colors.red;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'About',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: bgColor,
              child: ListView(
                padding: EdgeInsets.symmetric(
                    vertical: isTablet ? 8 : 4, horizontal: 0),
                children: [
                  _buildTile(Icons.person, 'Account Information', isTablet, _showAccountInfo, iconColor, textColor),
                  Divider(height: 1, thickness: 0.5, color: dividerColor),
                  ListTile(
                    leading: Icon(Icons.public, color: iconColor, size: isTablet ? 28 : 24),
                    title: Text('Country', style: TextStyle(fontSize: isTablet ? 17 : 15, color: textColor)),
                    subtitle: Text(selectedCountry, style: TextStyle(fontSize: isTablet ? 15 : 13, color: subTextColor)),
                    trailing: Icon(Icons.arrow_forward_ios, size: isTablet ? 20 : 16, color: subTextColor),
                    onTap: _chooseCountry,
                  ),
                  Divider(height: 1, thickness: 0.5, color: dividerColor),
                  ListTile(
                    leading: Icon(Icons.dark_mode, color: iconColor, size: isTablet ? 28 : 24),
                    title: Text('Dark Mode', style: TextStyle(fontSize: isTablet ? 17 : 15, color: textColor)),
                    trailing: Switch(
                      value: isDarkMode,
                      activeColor: Colors.red,
                      onChanged: (val) => setState(() => isDarkMode = val),
                    ),
                  ),
                  Divider(height: 1, thickness: 0.5, color: dividerColor),
                  _buildTile(Icons.policy, 'Policies', isTablet, _showPolicies, iconColor, textColor),
                  Divider(height: 1, thickness: 0.5, color: dividerColor),
                  _buildTile(Icons.help, 'Help & Support', isTablet, _showHelp, iconColor, textColor),
                  Divider(height: 1, thickness: 0.5, color: dividerColor),
                  _buildTile(Icons.feedback, 'Send Feedback', isTablet, _showFeedback, iconColor, textColor),
                  Divider(height: 1, thickness: 0.5, color: dividerColor),
                  _buildTile(Icons.info, 'About App', isTablet, _showAboutApp, iconColor, textColor),
                  Divider(height: 1, thickness: 0.5, color: dividerColor),
                ],
              ),
            ),
          ),
          Container(
            color: bgColor,
            padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
            child: ElevatedButton.icon(
              onPressed: _confirmLogout,
              icon: Icon(Icons.logout,
                  size: isTablet ? 22 : 18, color: Colors.white),
              label: Text('Logout',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: isTablet ? 17 : 15,
                      color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, isTablet ? 56 : 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildTile(IconData icon, String title, bool isTablet,
      VoidCallback onTap, Color iconColor, Color textColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: isTablet ? 28 : 24),
      title: Text(title,
          style: TextStyle(fontSize: isTablet ? 17 : 15, color: textColor)),
      trailing: Icon(Icons.arrow_forward_ios,
          size: isTablet ? 20 : 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}