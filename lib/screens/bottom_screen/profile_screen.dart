import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController =
      TextEditingController(text: 'Shreejal Shrestha');
  final TextEditingController emailController =
      TextEditingController(text: 'shreejal@trendora.com');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================= PROFILE IMAGE =================
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/picture10.png'),
            ),
            const SizedBox(height: 16),

            // ================= NAME FIELD =================
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // ================= EMAIL FIELD =================
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated!')),
                );
              },
              child: const Text('Save Changes'),
            ),

            const SizedBox(height: 20),
            const Divider(),

            // ================= OPTIONS =================
            ListTile(
              leading: const Icon(Icons.shopping_bag, color: Colors.blue),
              title: const Text('My Orders'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('My Orders tapped')),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.blue),
              title: const Text('Wishlist'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Wishlist tapped')),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings, color: Colors.blue),
              title: const Text('Settings'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings tapped')),
                );
              },
            ),

            const Divider(),

            // ================= LOGOUT =================
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
