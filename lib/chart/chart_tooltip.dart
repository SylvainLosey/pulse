import 'package:flutter/material.dart';
import '../models.dart';

class ChartTooltip extends StatelessWidget {
  final CategoryAmount category;
  final VoidCallback onTap;

  const ChartTooltip({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '${category.category}: CHF ${category.amount}',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
