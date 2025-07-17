import 'package:flutter/material.dart';
import 'package:expense_tracker/utils/constants/colors.dart';
import 'package:expense_tracker/screens/add_income_screen.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';
import '../data/local_data_manager.dart';
import 'edit_addscreen_data.dart';

// Transaction model is now imported from local_data_manager.dart

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  AddScreenState createState() => AddScreenState();
}

class AddScreenState extends State<AddScreen> {
  final LocalDataManager _dataManager = LocalDataManager();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _dataManager.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _dataManager.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {
        _isLoading = _dataManager.isLoading;
      });
    }
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _dataManager.initialize();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong: $error'),
            backgroundColor: TColors.errorPrimary,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteTransaction(Transaction transaction) async {
    try {
      await _dataManager.deleteTransaction(transaction.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction deleted successfully.'),
            backgroundColor: TColors.primary,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting transaction: $error'),
            backgroundColor: TColors.errorPrimary,
          ),
        );
      }
    }
  }

  Future<void> _showDeleteConfirmationDialog(Transaction transaction) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content:
              const Text('Are you sure you want to delete this transaction?'),
          backgroundColor: TColors.containerSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: TColors.secondary,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                await _deleteTransaction(transaction);
              },
              style: TextButton.styleFrom(
                foregroundColor: TColors.primary,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(TColors.primary),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 16,
                              color: TColors.primary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _dataManager.transactions.isEmpty
                      ? const Center(
                          child: Text('Add your first Income or Expense.'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _dataManager.transactions.length,
                          itemBuilder: (context, index) {
                            final transaction =
                                _dataManager.transactions[index];
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Dismissible(
                                key: Key(transaction.id),
                                background: Container(
                                  color: TColors.containerTertiary,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                secondaryBackground: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.delete, color: Colors.white),
                                    ],
                                  ),
                                ),
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    // Navigate to edit screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditAddScreenData(
                                          transaction: transaction,
                                          transactionType: transaction.isIncome
                                              ? 'income'
                                              : 'expense',
                                        ),
                                      ),
                                    ).then((_) => _dataManager.refreshData());
                                    return false;
                                  } else {
                                    // Show delete confirmation dialog
                                    await _showDeleteConfirmationDialog(
                                        transaction);
                                    return false; // Prevent dismissal
                                  }
                                },
                                child: ListTile(
                                  tileColor: Color(0xFFF6f6f6),
                                  contentPadding: const EdgeInsets.all(8),
                                  leading: Icon(
                                    transaction.isIncome
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: transaction.isIncome
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  title: Text(
                                    transaction.title,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  subtitle: Text(
                                    '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(color: Colors.black54),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        transaction.category,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(color: Colors.black54),
                                      ),
                                      Text(
                                        '${transaction.isIncome ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: transaction.isIncome
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Add Income Card
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddIncomeScreen(),
                        ),
                      ).then((_) =>
                          _dataManager.refreshData()); // Refresh after adding
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.containerTertiary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          size: 36,
                          color: TColors.textWhite,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add Income',
                          style: TextStyle(
                            fontSize: 14,
                            color: TColors.textWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Add Expense Card
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddExpenseScreen(),
                        ),
                      ).then((_) =>
                          _dataManager.refreshData()); // Refresh after adding
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.secondary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.remove_circle_outline,
                          size: 36,
                          color: TColors.textWhite,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add Expense',
                          style: TextStyle(
                            fontSize: 14,
                            color: TColors.containerSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
