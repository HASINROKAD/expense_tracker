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
          SnackBar(
            content: const Text('Transaction deleted successfully.'),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? TColors.primaryDark
                : TColors.primary,
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
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? TColors.surfaceDark
              : TColors.containerSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).brightness == Brightness.dark
                    ? TColors.textSecondaryDark
                    : TColors.secondary,
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 6),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).brightness == Brightness.dark
                                  ? TColors.primaryDark
                                  : TColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading transactions...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? TColors.primaryDark
                                  : TColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _dataManager.transactions.isEmpty
                      ? Center(
                          child: Text(
                            'Add your first Income or Expense.',
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? TColors.textSecondaryDark
                                  : TColors.textSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _dataManager.transactions.length,
                          itemBuilder: (context, index) {
                            final transaction =
                                _dataManager.transactions[index];
                            return Card(
                              elevation: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? 8
                                  : 3,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? TColors.surfaceDark
                                  : Colors.white,
                              shadowColor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black54
                                  : Colors.grey.withValues(alpha: 0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? TColors.borderDark
                                          .withValues(alpha: 0.3)
                                      : Colors.grey.withValues(alpha: 0.1),
                                  width: 1,
                                ),
                              ),
                              child: Dismissible(
                                key: Key(transaction.id),
                                background: Container(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? TColors.primaryDark
                                      : TColors.containerTertiary,
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
                                  tileColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: transaction.isIncome
                                          ? Colors.green.withValues(alpha: 0.1)
                                          : Colors.red.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: transaction.isIncome
                                            ? Colors.green
                                                .withValues(alpha: 0.3)
                                            : Colors.red.withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      transaction.isIncome
                                          ? Icons.trending_up_rounded
                                          : Icons.trending_down_rounded,
                                      color: transaction.isIncome
                                          ? Colors.green[600]
                                          : Colors.red[600],
                                      size: 24,
                                    ),
                                  ),
                                  title: Text(
                                    transaction.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? TColors.textPrimaryDark
                                              : TColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  subtitle: Text(
                                    '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? TColors.textSecondaryDark
                                              : Colors.black54,
                                        ),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? TColors.containerPrimaryDark
                                              : Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          transaction.category,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? TColors.textSecondaryDark
                                                    : Colors.black54,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${transaction.isIncome ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: transaction.isIncome
                                              ? Colors.green[600]
                                              : Colors.red[600],
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
                  elevation:
                      Theme.of(context).brightness == Brightness.dark ? 8 : 5,
                  shadowColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black54
                      : Colors.grey.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withValues(alpha: 0.1),
                          Colors.green.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.3),
                        width: 1,
                      ),
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
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.trending_up_rounded,
                            size: 32,
                            color: Colors.green[600],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add Income',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Add Expense Card
                Card(
                  elevation:
                      Theme.of(context).brightness == Brightness.dark ? 8 : 5,
                  shadowColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black54
                      : Colors.grey.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.withValues(alpha: 0.1),
                          Colors.red.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                        width: 1,
                      ),
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
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.trending_down_rounded,
                            size: 32,
                            color: Colors.red[600],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add Expense',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
