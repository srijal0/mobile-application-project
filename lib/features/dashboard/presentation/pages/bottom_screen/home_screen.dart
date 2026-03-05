import 'package:fashion_store_trendora/features/dashboard/presentation/view_model/sensor_view_model.dart';
import 'package:fashion_store_trendora/features/cart/presentation/cart_data.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SensorViewModel sensorVM = SensorViewModel();
  String searchQuery = '';

  // ── Product Data ──
  List<String> productImages = [
    'assets/images/picture1.png',
    'assets/images/picture2.png',
    'assets/images/picture3.png',
    'assets/images/picture4.png',
    'assets/images/picture5.png',
    'assets/images/picture6.png',
    'assets/images/picture7.png',
  ];

  List<String> productNames = [
    'Campus Muse',
    'Leap Theory',
    'Stripped V-Neck',
    'Zip-up Hoodie',
    'Hoodie',
    'Shirt',
    'Frock',
  ];

  List<double> productPrices = [3000, 5000, 4500, 2000, 3000, 4500, 6500];
  List<bool> productIsNew = [true, true, false, true, false, false, false];

  Map<String, List<int>> sections = {
    "Categories": [0, 1, 2, 3],
    "Best Sellers": [1, 2, 4],
    "New Arrivals": [],
  };

  @override
  void initState() {
    super.initState();

    // Generate New Arrivals
    sections["New Arrivals"] =
        List.generate(productIsNew.length, (i) => i).where((i) => productIsNew[i]).toList();

    // Sensor callbacks
    sensorVM.onShuffle = _shuffleProducts;
    sensorVM.onTiltMessage = _showTiltSnackbar;
    sensorVM.initSensors();
  }

  @override
  void dispose() {
    sensorVM.disposeSensors();
    super.dispose();
  }

  // ── Shuffle Products ──
  void _shuffleProducts() {
    setState(() {
      final combined = List.generate(
        productImages.length,
        (i) => {
          'image': productImages[i],
          'name': productNames[i],
          'price': productPrices[i],
          'isNew': productIsNew[i],
        },
      );

      combined.shuffle(Random());

      productImages = combined.map((e) => e['image'] as String).toList();
      productNames = combined.map((e) => e['name'] as String).toList();
      productPrices = combined.map((e) => e['price'] as double).toList();
      productIsNew = combined.map((e) => e['isNew'] as bool).toList();

      sections["New Arrivals"] =
          List.generate(productIsNew.length, (i) => i).where((i) => productIsNew[i]).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.shuffle, color: Colors.white),
            SizedBox(width: 6),
            Text('Products shuffled!'),
          ],
        ),
        backgroundColor: Color(0xFFDA1B2B),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showTiltSnackbar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.screen_rotation, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.deepOrange,
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ✅ Actually adds item to cartItems list
  void _addToCart(Map<String, dynamic> product) {
    final existingIndex = cartItems.indexWhere((item) => item['name'] == product['name']);

    if (existingIndex != -1) {
      // Item already in cart — increase quantity
      setState(() {
        cartItems[existingIndex]['qty']++;
      });
    } else {
      // New item — add to cart
      setState(() {
        cartItems.add({
          'image': product['image'],
          'name': product['name'],
          'price': (product['price'] as double).toInt(),
          'qty': 1,
        });
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart!'),
        backgroundColor: const Color(0xFFDA1B2B),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to cart tab (index 1)
            DefaultTabController.of(context);
          },
        ),
      ),
    );
  }

  // ✅ Opens product detail bottom sheet with name, price, image
  void _showProductDetail(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // Product Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  product['image'],
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 220,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 50),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Product Name
            Text(
              product['name'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            // Product Price
            Text(
              "Rs. ${(product['price'] as double).toInt()}",
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFFDA1B2B),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              "A premium quality fashion item from Trendora's exclusive collection. "
              "Perfect for everyday wear with a stylish and modern look.",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
            ),
            const SizedBox(height: 20),

            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDA1B2B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context); // close bottom sheet
                  _addToCart(product);   // add to cart
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      // ✅ Tap card to open product detail
      onTap: () => _showProductDetail(product),
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                product['image'],
                width: 150,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 150,
                  height: 100,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              "Rs.${product['price'].toInt()}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            // ✅ Cart button still works independently
            GestureDetector(
              onTap: () => _addToCart(product),
              child: const CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFFDA1B2B),
                child: Icon(Icons.shopping_cart, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget horizontalSection(String title, List<int> indexes) {
    final filteredData = <Map<String, dynamic>>[];
    for (int i in indexes) {
      if (i < productNames.length &&
          productNames[i].toLowerCase().contains(searchQuery.toLowerCase())) {
        filteredData.add({
          'image': productImages[i],
          'name': productNames[i],
          'price': productPrices[i],
          'isNew': productIsNew[i],
        });
      }
    }
    if (filteredData.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredData.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: buildProductCard(filteredData[index]),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: sensorVM,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: SafeArea(
            child: Column(
              children: [
                // Proximity Banner
                if (sensorVM.isNear)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    color: const Color(0xFFDA1B2B),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.front_hand, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '👀 Quick View Mode — Hand Detected!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Gyroscope Category Indicator
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  color: Colors.red.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.screen_rotation, color: Colors.red, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Viewing: ${sensorVM.sectionKeys[sensorVM.currentSectionIndex]}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Column(
                      children: [
                        const Text(
                          "Explore stylish clothes for you",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "📳 Shake=Shuffle  |  ✋ Near=QuickView  |  🔄 Tilt=Category",
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),

                        // Search Bar
                        TextField(
                          onChanged: (value) => setState(() => searchQuery = value),
                          decoration: InputDecoration(
                            hintText: "Search",
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Current Section
                        horizontalSection(
                          sensorVM.sectionKeys[sensorVM.currentSectionIndex],
                          sections[sensorVM.sectionKeys[sensorVM.currentSectionIndex]] ?? [],
                        ),

                        const SizedBox(height: 8),

                        // Other Sections
                        ...sections.entries
                            .where((e) => e.key != sensorVM.sectionKeys[sensorVM.currentSectionIndex])
                            .map((e) => horizontalSection(e.key, e.value))
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}