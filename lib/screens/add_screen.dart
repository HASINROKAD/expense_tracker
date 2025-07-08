import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:expense_tracker/utils/constants/colors.dart';
import 'package:expense_tracker/screens/add_income_screen.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';
import '../data/supabase_auth.dart';
import 'edit_addscreen_data.dart';

// Data model for transactions
class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isIncome;
  final String category;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
    required this.category,
  });
}

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  AddScreenState createState() => AddScreenState();
}

class AddScreenState extends State<AddScreen> {
  final supabase = Supabase.instance.client;
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      _isLoading = true;
    });

    final client = SupabaseAuth.client();
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to view transactions.'),
          backgroundColor: TColors.errorPrimary,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Fetch income records
      final incomeResponse = await supabase
          .from('tbl_add_income_data')
          .select()
          .eq('user_uuid', userId);

      final incomeTransactions = incomeResponse.map((record) {
        final date = DateTime.parse(
            record['income_date'] ?? DateTime.now().toIso8601String());
        return Transaction(
          id: record['id']?.toString() ?? record['uuid']?.toString() ?? '',
          // Fallback to uuid if id is missing
          title: record['payees_name'] ?? record['income_category'] ?? 'Income',
          amount: (record['income_amount'] as num?)?.toDouble() ?? 0.0,
          date: date,
          isIncome: true,
          category: record['income_category'] ?? 'Unknown',
        );
      }).toList();

      // Fetch expense records
      final expenseResponse = await supabase
          .from('tbl_add_expense_data')
          .select()
          .eq('user_uuid', userId);

      final expenseTransactions = expenseResponse.map((record) {
        final date = DateTime.parse(
            record['expense_date'] ?? DateTime.now().toIso8601String());
        return Transaction(
          id: record['id']?.toString() ?? record['uuid']?.toString() ?? '',
          // Fallback to uuid if id is missing
          title:
          record['payers_name'] ?? record['expense_category'] ?? 'Expense',
          amount: (record['expense_amount'] as num?)?.toDouble() ?? 0.0,
          date: date,
          isIncome: false,
          category: record['expense_category'] ?? 'Unknown',
        );
      }).toList();

      // Filter out transactions with empty id
      final validTransactions = [...incomeTransactions, ...expenseTransactions]
          .where((t) => t.id.isNotEmpty)
          .toList();

      // Combine and sort transactions by date (newest first)
      setState(() {
        _transactions = validTransactions
          ..sort((a, b) => b.date.compareTo(a.date));
        _isLoading = false;
      });

      if (validTransactions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No valid transactions found.'),
            backgroundColor: TColors.primary,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong: $error'),
          backgroundColor: TColors.errorPrimary,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteTransaction(Transaction transaction) async {
    try {
      final table =
      transaction.isIncome ? 'tbl_add_income_data' : 'tbl_add_expense_data';
      await supabase.from(table).delete().eq('id', transaction.id);
      await _fetchTransactions(); // Refresh the list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction deleted successfully.'),
          backgroundColor: TColors.primary,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting transaction: $error'),
          backgroundColor: TColors.errorPrimary,
        ),
      );
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
                  : _transactions.isEmpty
                  ? const Center(
                child: Text('Add your first Income or Expense.'),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
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
                                transactionType: transaction.isIncome ? 'income' : 'expense',
                              ),
                            ),
                          ).then((_) => _fetchTransactions());
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
                      ).then(
                              (_) => _fetchTransactions()); // Refresh after adding
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
                      ).then(
                              (_) => _fetchTransactions()); // Refresh after adding
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