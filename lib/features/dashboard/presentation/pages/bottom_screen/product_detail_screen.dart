import 'package:fashion_store_trendora/cart_data.dart';
import 'package:flutter/material.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final String image;
  final String name;
  final double price;
  final bool isNew;

  const ProductDetailScreen({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.isNew,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              image,
              width: double.infinity,
              height: 320,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isNew)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "New",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Rs. ${price.toInt()}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Product Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "This stylish clothing item is designed for comfort and modern fashion.",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 30),

                  // ADD TO CART BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Add item to global cart
                        cartItems.add({
                          'image': image,
                          'name': name,
                          'price': price.toInt(),
                          'oldPrice': (price * 1.2).toInt(), // example old price
                          'qty': 1,
                        });

                        // Navigate to Cart Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CartScreen()),
                        );
                      },
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}