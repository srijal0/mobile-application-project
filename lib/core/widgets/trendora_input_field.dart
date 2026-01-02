// lib/widgets/trendora_input_field.dart
import 'package:flutter/material.dart';

class TrendoraInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const TrendoraInputField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFDA1B2B)), // Trendora red
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFDA1B2B)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFDA1B2B), width: 2),
        ),
      ),
    );
  }
}
