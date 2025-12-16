import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ================= PRODUCT DATA =================
  static final List<Map<String, dynamic>> products = [
    {'image': 'assets/images/picture1.png', 'name': 'Campus Muse', 'price': 'Rs.3000', 'isNew': true},
    {'image': 'assets/images/picture2.png', 'name': 'Leap Theory', 'price': 'Rs.5000', 'isNew': true},
    {'image': 'assets/images/picture3.png', 'name': 'Stripped V-Neck', 'price': 'Rs.4500', 'isNew': false},
    {'image': 'assets/images/picture4.png', 'name': 'Zip-up Hoodie', 'price': 'Rs.2000', 'isNew': true},
    {'image': 'assets/images/picture5.png', 'name': 'Hoodie', 'price': 'Rs.3000', 'isNew': false},
    {'image': 'assets/images/picture6.png', 'name': 'Shirt', 'price': 'Rs.4500', 'isNew': false},
    {'image': 'assets/images/picture7.png', 'name': 'Frock', 'price': 'Rs.6500', 'isNew': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.menu, size: 28),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/dp.png'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // TITLE
              const Text(
                "Explore stylish furniture for you",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // SEARCH + FILTER
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // BEST OFFER TITLE
              const Text(
                "Best offer",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              // GRID PRODUCT CARDS (2 per row)
              Expanded(
                child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 products per row
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.7, // adjust height/width
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      image: product['image'],
                      name: product['name'],
                      price: product['price'],
                      isNew: product['isNew'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= PRODUCT CARD =================
class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final bool isNew;

  const ProductCard({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 120,
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 40),
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // NEW LABEL + CART BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isNew)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "New",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.shopping_cart, size: 18, color: Colors.white),
                ),
              ],
            ),
          ),

          // PRODUCT NAME
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // PRICE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              price,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: HomeScreen()));
}
