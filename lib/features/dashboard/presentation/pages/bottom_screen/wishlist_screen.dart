// lib/features/wishlist/presentation/pages/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:fashion_store_trendora/core/widgets/my_product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example wishlist items (later connect to Riverpod provider or Hive storage)
    final wishlistItems = [
      {
        "title": "Leather Jacket",
        "brand": "Zara",
        "image": "assets/images/jacket.jpg",
        "price": 5500,
      },
      {
        "title": "Sneakers",
        "brand": "Nike",
        "image": "assets/images/sneakers.jpg",
        "price": 4500,
      },
      {
        "title": "Handbag",
        "brand": "Gucci",
        "image": "assets/images/bag.jpg",
        "price": 12000,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Wishlist",
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
        child: wishlistItems.isEmpty
            ? const Center(
                child: Text(
                  "Your wishlist is empty",
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: wishlistItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final item = wishlistItems[index];
                    return MyProductCard(
                      title: item["title"] as String,
                      brand: item["brand"] as String,
                      image: item["image"] as String,
                      price: item["price"] as int,
                    );
                  },
                ),
              ),
      ),
    );
  }
}
