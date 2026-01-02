import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';

  // ================= PRODUCT DATA =================
  final List<String> productImages = [
    'assets/images/picture1.png',
    'assets/images/picture2.png',
    'assets/images/picture3.png',
    'assets/images/picture4.png',
    'assets/images/picture5.png',
    'assets/images/picture6.png',
    'assets/images/picture7.png',
  ];

  final List<String> productNames = [
    'Campus Muse',
    'Leap Theory',
    'Stripped V-Neck',
    'Zip-up Hoodie',
    'Hoodie',
    'Shirt',
    'Frock',
  ];

  final List<double> productPrices = [
    3000,
    5000,
    4500,
    2000,
    3000,
    4500,
    6500,
  ];

  final List<bool> productIsNew = [
    true,
    true,
    false,
    true,
    false,
    false,
    false,
  ];

  final Map<String, List<int>> sections = {
    "Categories": [0, 1, 2, 3],
    "Best Sellers": [1, 2, 4],
    "New Arrivals": [],
  };

  @override
  void initState() {
    super.initState();
    sections["New Arrivals"] = List.generate(productIsNew.length, (i) => i)
        .where((i) => productIsNew[i])
        .toList();
  }

  // ================= HORIZONTAL SECTION =================
  Widget horizontalSection(String title, List<int> indexes) {
    final filteredData = <Map<String, dynamic>>[];

    for (int i in indexes) {
      if (productNames[i]
          .toLowerCase()
          .contains(searchQuery.toLowerCase())) {
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              final product = filteredData[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(
                        image: product['image'],
                        name: product['name'],
                        price: product['price'],
                        isNew: product['isNew'],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          product['image'],
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // NEW + CART
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (product['isNew'])
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF38B120), // Trendora green
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "New",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CartScreen(),
                                ),
                              );
                            },
                            child: const CircleAvatar(
                              radius: 16,
                              backgroundColor: Color(0xFFDA1B2B), // Trendora red
                              child: Icon(
                                Icons.shopping_cart,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Rs.${product['price'].toInt()}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
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

              const Text(
                "Explore stylish clothes for you",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // SEARCH
              TextField(
                onChanged: (value) {
                  setState(() => searchQuery = value);
                },
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

              const SizedBox(height: 20),

              // SECTIONS
              Expanded(
                child: ListView(
                  children: sections.entries
                      .map((e) => horizontalSection(e.key, e.value))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
