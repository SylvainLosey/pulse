import 'package:flutter/material.dart';
import 'cash_flow_chart.dart';
import 'models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cashFlow = MonthlyCashFlow(
      month: 'October 2023',
      income: [
        CategoryAmount(category: 'Salary', amount: 6500),
        CategoryAmount(category: 'Side Project', amount: 400),
        CategoryAmount(category: 'Investments', amount: 300),
      ],
      expenses: [
        CategoryAmount(category: 'Rent', amount: 2200),
        CategoryAmount(category: 'Groceries', amount: 800),
        CategoryAmount(category: 'Health Insurance', amount: 480),
        CategoryAmount(category: 'Transport', amount: 250),
        CategoryAmount(category: 'Restaurants', amount: 400),
        CategoryAmount(category: 'Entertainment', amount: 300),
        CategoryAmount(category: 'Internet & Phone', amount: 120),
      ],
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Monthly Cash Flow')),
        body: CashFlowChart(cashFlow: cashFlow),
      ),
    );
  }
}
