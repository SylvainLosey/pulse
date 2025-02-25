import 'package:flutter/material.dart';
import '../models.dart';

class ChartTooltip extends StatelessWidget {
  final CategoryAmount category;
  final VoidCallback onTap;
  final BoxConstraints constraints;
  final Offset position;

  const ChartTooltip({
    super.key,
    required this.category,
    required this.onTap,
    required this.constraints,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
      delegate: _TooltipPositionDelegate(
        position: position,
        constraints: constraints,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '${category.category}: CHF ${category.amount}',
            style: const TextStyle(
              color: Color(0xFF2C3E50), // Dark blue-grey color
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _TooltipPositionDelegate extends SingleChildLayoutDelegate {
  final Offset position;
  final BoxConstraints constraints;

  _TooltipPositionDelegate({
    required this.position,
    required this.constraints,
  });

  @override
  BoxConstraints getConstraints(BoxConstraints constraints) {
    // Allow the tooltip to size to its content
    return const BoxConstraints();
  }

  @override
  Size getSize(BoxConstraints constraints) {
    // Use the parent constraints for the layout size
    return Size(this.constraints.maxWidth, this.constraints.maxHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double x = position.dx;
    double y = position.dy;

    // Ensure the tooltip doesn't go off the right edge
    if (x + childSize.width > constraints.maxWidth) {
      x = constraints.maxWidth - childSize.width;
    }

    // Ensure the tooltip doesn't go off the left edge
    if (x < 0) {
      x = 0;
    }

    // Show tooltip above the tap point if there's not enough space below
    if (y + childSize.height > constraints.maxHeight) {
      y = y - childSize.height - 16;
    }

    // Ensure the tooltip doesn't go off the top edge
    if (y < 0) {
      y = 8;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_TooltipPositionDelegate oldDelegate) {
    return position != oldDelegate.position ||
        constraints != oldDelegate.constraints;
  }
}
