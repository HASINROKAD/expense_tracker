import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';
import 'dynamic_text_row.dart';

class ScrollableRowCardWidget extends StatefulWidget {
  const ScrollableRowCardWidget({
    super.key,
    required this.scrollController,
    required this.currentBalance,
    required this.endOfMonthBalance,
    required this.thisWeekBalance,
    required this.thisMonthBalance,
    required this.thisWeekIncome,
    required this.thisMonthIncome,
    required this.yearToDateIncome,
    required this.todayExpense,
    required this.thisWeekExpense,
    required this.thisMonthExpense,
    required this.yearToDateExpense,
  });

  final ScrollController scrollController;
  final double currentBalance;
  final double endOfMonthBalance;
  final double thisWeekBalance;
  final double thisMonthBalance;
  final double thisWeekIncome;
  final double thisMonthIncome;
  final double yearToDateIncome;
  final double todayExpense;
  final double thisWeekExpense;
  final double thisMonthExpense;
  final double yearToDateExpense;

  @override
  State<ScrollableRowCardWidget> createState() =>
      _ScrollableRowCardWidgetState();
}

class _ScrollableRowCardWidgetState extends State<ScrollableRowCardWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      const firstCardWidth = 350  ;
      const expenseCardHalfWidth = 350 / 2;
      final screenWidth = MediaQuery.of(context).size.width;
      final offset = firstCardWidth + expenseCardHalfWidth - (screenWidth / 2);

      widget.scrollController.jumpTo(
        offset.clamp(0.0, widget.scrollController.position.maxScrollExtent),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: widget.scrollController, // Attach the ScrollController
      child: Row(
        children: [
          // First Card: Income Summary
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 300,
              maxWidth: 350,
              minHeight: 200,
              maxHeight: 300,
            ),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.only(left: 16, right: 8, bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details About Income',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: TColors.primary),
                    ),
                    const SizedBox(height: 20),
                    DynamicTextRow(
                      label: 'This Week Income:',
                      value: widget.thisWeekIncome.toStringAsFixed(2),
                      valueColor: Colors.green,
                    ),
                    DynamicTextRow(
                      label: 'This Month Income:',
                      value: widget.thisMonthIncome.toStringAsFixed(2),
                      valueColor: Colors.green,
                    ),
                    DynamicTextRow(
                      label: 'Year to Date Income:',
                      value: widget.yearToDateIncome.toStringAsFixed(2),
                      valueColor: Colors.green,
                    ),
                    DynamicTextRow(
                      label: '',
                      value: widget.yearToDateIncome.toStringAsFixed(2),
                      valueColor: Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Second Card: Expense Summary
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 300,
              maxWidth: 350,
              minHeight: 200,
              maxHeight: 300,
            ),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details About Expense',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: TColors.primary),
                    ),
                    const SizedBox(height: 20),
                    DynamicTextRow(
                      label: 'Today Expense:',
                      value: widget.todayExpense.toStringAsFixed(2),
                      valueColor: Colors.red,
                    ),
                    DynamicTextRow(
                      label: 'This Week Expense:',
                      value: widget.thisWeekExpense.toStringAsFixed(2),
                      valueColor: Colors.red,
                    ),
                    DynamicTextRow(
                      label: 'This Month Expense:',
                      value: widget.thisMonthExpense.toStringAsFixed(2),
                      valueColor: Colors.red,
                    ),
                    DynamicTextRow(
                      label: 'Year to Date Expense:',
                      value: widget.yearToDateExpense.toStringAsFixed(2),
                      valueColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Third Card: Balance Summary
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 300,
              maxWidth: 350,
              minHeight: 200,
              maxHeight: 300,
            ),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.only(left: 8, right: 16, bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details About Balance',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: TColors.primary),
                    ),
                    const SizedBox(height: 20),
                    DynamicTextRow(
                      label: 'Current Balance:',
                      value: widget.currentBalance.toStringAsFixed(2),
                    ),
                    DynamicTextRow(
                      label: 'This Week Balance:',
                      value: widget.endOfMonthBalance.toStringAsFixed(2),
                    ),
                    DynamicTextRow(
                      label: 'This Month Balance:',
                      value: widget.thisWeekBalance.toStringAsFixed(2),
                    ),
                    DynamicTextRow(
                      label: 'Year to Date Balance:',
                      value: widget.thisMonthBalance.toStringAsFixed(2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
