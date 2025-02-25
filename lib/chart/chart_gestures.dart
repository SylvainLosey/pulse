import 'package:flutter/material.dart';

/// Handles swipe gestures for month navigation
class ChartGestureHandler {
  final Function(int direction) onMonthChanged;
  static const double minSwipeDistance = 50.0;
  double _dragStartX = 0;

  ChartGestureHandler({required this.onMonthChanged});

  void handleDragStart(DragStartDetails details) {
    _dragStartX = details.globalPosition.dx;
  }

  void handleDragEnd(DragEndDetails details) {
    final dragDistance = details.globalPosition.dx - _dragStartX;
    if (dragDistance.abs() > minSwipeDistance) {
      // Swipe left = previous month, right = next month
      final direction = dragDistance > 0 ? 1 : -1;
      onMonthChanged(direction);
    }
  }
}
