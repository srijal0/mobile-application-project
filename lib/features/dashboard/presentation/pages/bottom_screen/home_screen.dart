// lib/features/home/presentation/pages/home_screen.dart
import 'package:flutter/material.dart';
import 'package:fashion_store_trendora/core/widgets/my_product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 5),

              // 🔥 Trendora Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/icons/trendora_icon.png", height: 40),
                  const SizedBox(width: 8),
                  RichText(
                    text: const TextSpan(
                      text: "Trend",
                      style: TextStyle(
                        fontFamily: "OpenSansBold",
                        fontSize: 32,
                        letterSpacing: 2,
                        color: Color(0xFF38B120), // Trendora green
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "ora",
                          style: TextStyle(
                            color: Color(0xFFFFAE37), // Trendora yellow
                            fontFamily: "OpenSansRegular",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.notifications, size: 32),
                ],
              ),

              const SizedBox(height: 20),

              // 🔍 Search bar
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Search for fashion items",
                        fillColor: const Color(0xFFe7dbcf),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFe7dbcf)),
                          borderRadius: BorderRadius.circular(55),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFFFAE37)),
                          borderRadius: BorderRadius.circular(55),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      shape: const CircleBorder(),
                      gradient: RadialGradient(
                        center: Alignment.topCenter,
                        radius: 1.5,
                        colors: [
                          Colors.greenAccent.shade400,
                          Colors.green.shade700,
                        ],
                      ),
                    ),
                    child: const Icon(Icons.search, color: Colors.white, size: 28),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 🏆 Best Selling Section
              Row(
                children: [
                  const Text(
                    "Best Selling",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFFFAE37),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  MyProductCard(
                    title: "Denim Jacket",
                    brand: "Levi's",
                    image: 'assets/images/jacket.jpg',
                    price: 2500,
                  ),
                  MyProductCard(
                    title: "Sneakers",
                    brand: "Nike",
                    image: 'assets/images/sneakers.jpg',
                    price: 4500,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // 🌟 Popular Section
              Row(
                children: [
                  const Text(
                    "Popular",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFFFAE37),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  MyProductCard(
                    title: "Summer Dress",
                    brand: "Zara",
                    image: 'assets/images/dress.jpg',
                    price: 3200,
                  ),
                  MyProductCard(
                    title: "Leather Bag",
                    brand: "Gucci",
                    image: 'assets/images/bag.jpg',
                    price: 12000,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
