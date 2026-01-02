import 'package:flutter/material.dart';

class MyProgressBar extends StatelessWidget {
  final int notProgressFlex;

  const MyProgressBar({
    super.key,
    this.notProgressFlex = 5,
  });

  @override
  Widget build(BuildContext context) {
    final int total = 10;
    final int notFlex = notProgressFlex.clamp(0, total);
    final int progressFlex = (total - notFlex).clamp(1, total);

    return Row(
      children: [
        Expanded(
          flex: progressFlex,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF38B120),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          flex: notFlex,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
