import 'package:flutter/material.dart';
import 'models.dart';

class MonthScale extends StatelessWidget {
  final List<MonthlyCashFlow> cashFlows;
  final int currentIndex;

  const MonthScale({
    super.key,
    required this.cashFlows,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            cashFlows[currentIndex].month,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(cashFlows.length, (index) {
              // Reverse the index to match swipe direction
              final reversedIndex = cashFlows.length - 1 - index;
              final isSelected = reversedIndex == currentIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
