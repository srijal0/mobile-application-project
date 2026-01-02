//about screen code
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Trendora',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '👕 About Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Row(
              children: const [
                Icon(Icons.person, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  'Developed by Shreejal Shrestha',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: const [
                Icon(Icons.email, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  'support@trendora.com',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: const [
                Icon(Icons.phone, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  '+977-9812987643',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  'Kathmandu, Nepal',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Trendora is a modern clothing and fashion shopping app '
              'that allows users to explore the latest trends, '
              'browse collections, and shop seamlessly.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),

            const SizedBox(height: 24),

            const Text(
              'Version: 1.0.0',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
