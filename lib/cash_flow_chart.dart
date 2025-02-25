import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'models.dart';
import 'chart/segment_data.dart';
import 'chart/chart_layout.dart';
import 'chart/chart_painter.dart';
import 'chart/chart_hit_detector.dart';
import 'chart/chart_tooltip.dart';

class CashFlowChart extends StatefulWidget {
  final MonthlyCashFlow cashFlow;

  const CashFlowChart({super.key, required this.cashFlow});

  @override
  State<CashFlowChart> createState() => _CashFlowChartState();
}

class _CashFlowChartState extends State<CashFlowChart> {
  CategoryAmount? selectedCategory;
  Offset? tooltipPosition;

  static const greenShades = [
    Color(0xFF81C784),
    Color(0xFF4CAF50),
    Color(0xFF388E3C),
    Color(0xFF1B5E20),
  ];

  static const redShades = [
    Color(0xFFE57373),
    Color(0xFFF44336),
    Color(0xFFD32F2F),
    Color(0xFFB71C1C),
  ];

  void _handleTap(Offset position, ChartHitDetector detector) {
    final hit = detector.detectHit(position);
    setState(() {
      if (hit != null) {
        selectedCategory = hit.category;
        tooltipPosition = Offset(position.dx, position.dy - 8);
      } else {
        selectedCategory = null;
        tooltipPosition = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.cashFlow.month,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              final layout = ChartLayout(size: size);
              final detector = ChartHitDetector(
                layout: layout,
                cashFlow: widget.cashFlow,
              );

              return Stack(
                children: [
                  GestureDetector(
                    onTapDown: (details) => _handleTap(
                      details.localPosition,
                      detector,
                    ),
                    child: CustomPaint(
                      painter: ChartPainter(
                        income: widget.cashFlow.income,
                        expenses: widget.cashFlow.expenses,
                        totalIncome: widget.cashFlow.totalIncome,
                        totalExpenses: widget.cashFlow.totalExpenses,
                        greenShades: greenShades,
                        redShades: redShades,
                        layout: layout,
                      ),
                      size: Size.infinite,
                    ),
                  ),
                  if (selectedCategory != null && tooltipPosition != null)
                    Positioned(
                      left: tooltipPosition!.dx,
                      top: tooltipPosition!.dy,
                      child: ChartTooltip(
                        category: selectedCategory!,
                        onTap: () => setState(() {
                          selectedCategory = null;
                          tooltipPosition = null;
                        }),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
