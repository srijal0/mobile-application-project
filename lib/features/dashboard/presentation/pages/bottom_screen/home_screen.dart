import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';

  // ── Sensor Subscriptions ──
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<int>? _proximitySubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  // ── Sensor State ──
  DateTime? _lastShakeTime;
  DateTime? _lastTiltTime;
  bool _isNear = false;

  // ── Gyroscope: current category index ──
  int _currentSectionIndex = 0;
  final List<String> _sectionKeys = ["Categories", "Best Sellers", "New Arrivals"];

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

  List<double> productPrices = [
    3000,
    5000,
    4500,
    2000,
    3000,
    4500,
    6500,
  ];

  List<bool> productIsNew = [
    true,
    true,
    false,
    true,
    false,
    false,
    false,
  ];

  Map<String, List<int>> sections = {
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

    // ── 1. Accelerometer Sensor (Shake to shuffle) ──
    _accelerometerSubscription =
        accelerometerEventStream().listen((AccelerometerEvent event) {
      _detectShake(event);
    });

    // ── 2. Proximity Sensor (Hand near = Quick View) ──
    _proximitySubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event == 1);
      });
    });

    // ── 3. Gyroscope Sensor (Tilt to switch category) ──
    _gyroscopeSubscription =
        gyroscopeEventStream().listen((GyroscopeEvent event) {
      _detectTilt(event);
    });
  }

  // ── Accelerometer: Detect Shake ──
  void _detectShake(AccelerometerEvent event) {
    final double acceleration =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    const double shakeThreshold = 15.0;

    if (acceleration > shakeThreshold) {
      final now = DateTime.now();
      if (_lastShakeTime == null ||
          now.difference(_lastShakeTime!) > const Duration(seconds: 1)) {
        _lastShakeTime = now;
        _shuffleProducts();
      }
    }
  }

  // ── Gyroscope: Detect Tilt ──
  void _detectTilt(GyroscopeEvent event) {
    const double tiltThreshold = 2.0;
    final now = DateTime.now();

    if (_lastTiltTime != null &&
        now.difference(_lastTiltTime!) < const Duration(milliseconds: 800)) {
      return;
    }

    if (event.y > tiltThreshold) {
      // Tilt right → next category
      _lastTiltTime = now;
      setState(() {
        _currentSectionIndex =
            (_currentSectionIndex + 1) % _sectionKeys.length;
      });
      _showTiltSnackbar('➡️ ${_sectionKeys[_currentSectionIndex]}');
    } else if (event.y < -tiltThreshold) {
      // Tilt left → previous category
      _lastTiltTime = now;
      setState(() {
        _currentSectionIndex =
            (_currentSectionIndex - 1 + _sectionKeys.length) %
                _sectionKeys.length;
      });
      _showTiltSnackbar('⬅️ ${_sectionKeys[_currentSectionIndex]}');
    }
  }

  void _showTiltSnackbar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.screen_rotation, color: Colors.white),
            const SizedBox(width: 8),
            Text('Category: $message'),
          ],
        ),
        backgroundColor: Colors.deepOrange,
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Shuffle products ──
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

      sections["New Arrivals"] = List.generate(productIsNew.length, (i) => i)
          .where((i) => productIsNew[i])
          .toList();
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

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _proximitySubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }

  void _addToCart(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart!'),
        backgroundColor: const Color(0xFFDA1B2B),
      ),
    );
  }

  Widget buildProductCard(Map<String, dynamic> product) {
    return SizedBox(
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
          Text(product['name'],
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text("Rs.${product['price'].toInt()}",
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
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
        Text(title,
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            // ── Proximity Banner ──
            if (_isNear)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 16),
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

            // ── Gyroscope Category Indicator ──
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              color: Colors.red.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.screen_rotation,
                      color: Colors.red, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Viewing: ${_sectionKeys[_currentSectionIndex]}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // ── Main Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                child: Column(
                  children: [
                    const Text(
                      "Explore stylish clothes for you",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
                      onChanged: (value) =>
                          setState(() => searchQuery = value),
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

                    // Show only current section based on gyroscope tilt
                    horizontalSection(
                      _sectionKeys[_currentSectionIndex],
                      sections[_sectionKeys[_currentSectionIndex]] ?? [],
                    ),

                    const SizedBox(height: 8),

                    // Show all sections below
                    ...sections.entries
                        .where((e) =>
                            e.key != _sectionKeys[_currentSectionIndex])
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
  }
}