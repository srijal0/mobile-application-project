import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';

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

  Widget buildProductCard(Map<String, dynamic> product) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              product['image'],
              width: 150,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, size: 80, color: Colors.grey);
              },
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (product['isNew'])
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFF38B120),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "New",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              const CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFFDA1B2B),
                child: Icon(Icons.shopping_cart, size: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            product['name'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            "Rs.${product['price'].toInt()}",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget horizontalSection(String title, List<int> indexes) {
    final filteredData = <Map<String, dynamic>>[];

    for (int i in indexes) {
      if (productNames[i].toLowerCase().contains(searchQuery.toLowerCase())) {
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
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.menu, size: 26),
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/images/dp.png'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                "Explore stylish clothes for you",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: (value) {
                  setState(() => searchQuery = value);
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...sections.entries
                  .map((e) => horizontalSection(e.key, e.value))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
