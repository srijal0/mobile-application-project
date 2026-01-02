import 'package:flutter/material.dart';
import 'trendora_input_field.dart';

class MyInputFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final bool obscureText;
  final TextInputType? inputType;
  final Widget? icon;
  final String? Function(String?)? validator;

  const MyInputFormField({
    super.key,
    required this.controller,
    this.labelText,
    this.obscureText = false,
    this.inputType,
    this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Text(labelText!, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 6),
        TrendoraInputField(
          controller: controller,
          label: labelText ?? '',
          obscureText: obscureText,
          keyboardType: inputType ?? TextInputType.text,
          validator: validator,
        ),
      ],
    );
  }
}
