import 'package:flutter/material.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final int amount;

  const PaymentScreen({super.key, required this.amount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DETAILS CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Date: 13th June\nTime: 9:00 AM\nPackage: Online Clothing Order",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Price: Rs. ${widget.amount}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // PAYMENT METHOD
            const Text(
              "Select a payment method",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                _paymentOption("eSewa", 'assets/images/picture8.png'),
                const SizedBox(width: 12),
                _paymentOption("Khalti", 'assets/images/picture9.png'),
              ],
            ),

            const Spacer(),

            // CONFIRM BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedMethod.isEmpty ? Colors.grey : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: selectedMethod.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentSuccessScreen(
                              amount: widget.amount,
                            ),
                          ),
                        );
                      },
                child: const Text(
                  "Confirm",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // PAYMENT OPTION WITH MEDIUM LOGO
  Widget _paymentOption(String title, String logoPath) {
    final isSelected = selectedMethod == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedMethod = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.green : Colors.grey.shade300,
              width: 2,
            ),
            color: isSelected ? Colors.green.shade50 : Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                logoPath,
                width: 45,   // ✅ Medium size
                height: 45,  // ✅ Medium size
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isSelected ? Colors.green : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
