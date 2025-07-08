import 'package:expense_tracker/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/supabase_auth.dart';
import '../utils/constants/colors.dart';
import 'package:expense_tracker/widgets/dynamic_text_row.dart';
import 'package:expense_tracker/theme/custom_theme/dropdown_button_theme.dart';
import 'package:expense_tracker/widgets/scrollable_row_card_widget.dart';

// Data model for transactions
class Transaction {
  final String title;
  final double amount;
  final DateTime date;
  final bool isIncome;
  final String category;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
    required this.category,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;

  // Financial metrics to be computed dynamically
  double totalIncome = 0.0;
  double totalExpenses = 0.0;
  double currentBalance = 0.0;
  double endOfMonthBalance = 0.0;
  double thisWeekBalance = 0.0;
  double thisMonthBalance = 0.0;
  double thisWeekIncome = 0.0;
  double thisMonthIncome = 0.0;
  double yearToDateIncome = 0.0;
  double todayExpense = 0.0;
  double thisWeekExpense = 0.0;
  double thisMonthExpense = 0.0;
  double yearToDateExpense = 0.0;

  // Category-wise totals
  Map<String, double> incomeCategories = {};
  Map<String, double> expenseCategories = {};

  // List of all transactions
  List<Transaction> transactions = [];

  // Dropdown items based on selected category
  List<String> _items = [];
  String? _selectedItem;

  // Segmented button state
  String _selectedCategory = 'Expense';

  // ScrollController to control the horizontal scroll
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch transactions on screen load
    _fetchTransactions();
    // Schedule the scroll to center the "Details About Expense" card after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        316,
        // Adjusted to center the Expense card (Income card width + margins)
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
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
          content: Text('Error: You must be logged in to view transactions.'),
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
        final date = DateTime.parse(record['income_date']?.toString() ??
            DateTime.now().toIso8601String());
        return Transaction(
          title: record['payees_name']?.toString() ??
              record['income_category']?.toString() ??
              'Income',
          amount: (record['income_amount'] as num?)?.toDouble() ?? 0.0,
          date: date,
          isIncome: true,
          category: record['income_category']?.toString() ?? 'Unknown',
        );
      }).toList();

      // Fetch expense records
      final expenseResponse = await supabase
          .from('tbl_add_expense_data')
          .select()
          .eq('user_uuid', userId);

      final expenseTransactions = expenseResponse.map((record) {
        final date = DateTime.parse(record['expense_date']?.toString() ??
            DateTime.now().toIso8601String());
        return Transaction(
          title: record['payers_name']?.toString() ??
              record['expense_category']?.toString() ??
              'Expense',
          amount: (record['expense_amount'] as num?)?.toDouble() ?? 0.0,
          date: date,
          isIncome: false,
          category: record['expense_category']?.toString() ?? 'Unknown',
        );
      }).toList();

      // Combine transactions
      transactions = [...incomeTransactions, ...expenseTransactions];

      // Calculate current date boundaries
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final monthStart = DateTime(now.year, now.month, 1);
      final yearStart = DateTime(now.year, 1, 1);

      // Calculate financial metrics
      final incomeList = transactions.where((t) => t.isIncome).toList();
      final expenseList = transactions.where((t) => !t.isIncome).toList();

      // Total Income and Expenses
      totalIncome = incomeList.fold(0.0, (sum, t) => sum + t.amount);
      totalExpenses = expenseList.fold(0.0, (sum, t) => sum + t.amount);

      // Current Balance (Income - Expenses)
      currentBalance = totalIncome - totalExpenses;

      // End of Month Balance (simplified as current balance)
      endOfMonthBalance = currentBalance;

      // This Week Balance (Income - Expenses for this week)
      thisWeekIncome = incomeList
          .where((t) =>
      t.date.isAfter(weekStart) || t.date.isAtSameMomentAs(weekStart))
          .fold(0.0, (sum, t) => sum + t.amount);
      thisWeekExpense = expenseList
          .where((t) =>
      t.date.isAfter(weekStart) || t.date.isAtSameMomentAs(weekStart))
          .fold(0.0, (sum, t) => sum + t.amount);
      thisWeekBalance = thisWeekIncome - thisWeekExpense;

      // This Month Balance (Income - Expenses for this month)
      thisMonthIncome = incomeList
          .where((t) =>
      t.date.isAfter(monthStart) || t.date.isAtSameMomentAs(monthStart))
          .fold(0.0, (sum, t) => sum + t.amount);
      thisMonthExpense = expenseList
          .where((t) =>
      t.date.isAfter(monthStart) || t.date.isAtSameMomentAs(monthStart))
          .fold(0.0, (sum, t) => sum + t.amount);
      thisMonthBalance = thisMonthIncome - thisMonthExpense;

      // Year-to-Date Income and Expense
      yearToDateIncome = incomeList
          .where((t) =>
      t.date.isAfter(yearStart) || t.date.isAtSameMomentAs(yearStart))
          .fold(0.0, (sum, t) => sum + t.amount);
      yearToDateExpense = expenseList
          .where((t) =>
      t.date.isAfter(yearStart) || t.date.isAtSameMomentAs(yearStart))
          .fold(0.0, (sum, t) => sum + t.amount);

      // Today Expense
      todayExpense = expenseList
          .where((t) =>
      t.date.isAfter(todayStart) || t.date.isAtSameMomentAs(todayStart))
          .fold(0.0, (sum, t) => sum + t.amount);

      // Calculate category-wise totals
      incomeCategories = {};
      for (var transaction in incomeList) {
        incomeCategories[transaction.category] =
            (incomeCategories[transaction.category] ?? 0.0) +
                transaction.amount;
      }

      expenseCategories = {};
      for (var transaction in expenseList) {
        expenseCategories[transaction.category] =
            (expenseCategories[transaction.category] ?? 0.0) +
                transaction.amount;
      }

      // Update dropdown items based on default 'Expense' category, including 'All'
      _items = ['All', ...expenseCategories.keys];
      _selectedItem = _items.isNotEmpty ? _items.first : null;

      // Update state with computed metrics
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something wrong, Try Again'),
          backgroundColor: TColors.errorPrimary,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double balance = totalIncome - totalExpenses;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // First Card: Balance Summary
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Balance Summary',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: TColors.primary),
                      ),
                      const SizedBox(height: 20),
                      DynamicTextRow(
                        label: 'Total Income:',
                        value: totalIncome.toStringAsFixed(2),
                        valueColor: Colors.green,
                      ),
                      DynamicTextRow(
                        label: 'Total Expenses:',
                        value: totalExpenses.toStringAsFixed(2),
                        valueColor: Colors.red,
                      ),
                      DynamicTextRow(
                        label: 'Balance:',
                        value: balance.toStringAsFixed(2),
                        valueColor: balance >= 0 ? Colors.green : Colors.red,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Scrollable Row for Balance, Income, and Expense Cards
              _isLoading
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
                  : ScrollableRowCardWidget(
                scrollController: _scrollController,
                currentBalance: currentBalance,
                endOfMonthBalance: endOfMonthBalance,
                thisWeekBalance: thisWeekBalance,
                thisMonthBalance: thisMonthBalance,
                thisWeekIncome: thisWeekIncome,
                thisMonthIncome: thisMonthIncome,
                yearToDateIncome: yearToDateIncome,
                thisWeekExpense: thisWeekExpense,
                thisMonthExpense: thisMonthExpense,
                yearToDateExpense: yearToDateExpense,
                todayExpense: todayExpense,
              ),
              const SizedBox(height: 16),
              // Dropdown and Segmented Button Row
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    dropdownColor: TColors.containerSecondary,
                    menuMaxHeight: 200,
                    underline: Container(),
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 2,
                    style: DropdownStyle.getDropdownMenuItemStyle(),
                    value: _selectedItem,
                    items: _items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: DropdownStyle.getDropdownMenuItemStyle(),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedItem = newValue;
                      });
                    },
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 200,
                    ),
                    child: SegmentedButton<String>(
                      style: SegmentedButton.styleFrom(
                        selectedBackgroundColor: TColors.containerSecondary,
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      segments: const [
                        ButtonSegment<String>(
                          value: 'Expense',
                          label: Text('Expense'),
                        ),
                        ButtonSegment<String>(
                          value: 'Income',
                          label: Text('Income'),
                        ),
                      ],
                      selected: {_selectedCategory},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          _selectedCategory = newSelection.first;
                          // Update dropdown items based on selected category, including 'All'
                          _items = _selectedCategory == 'Income'
                              ? ['All', ...incomeCategories.keys]
                              : ['All', ...expenseCategories.keys];
                          _selectedItem =
                          _items.isNotEmpty ? _items.first : null;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Transaction ListView
              Container(
                height: 200, // Fixed height for the scrollable list
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    itemCount: transactions
                        .where((t) =>
                    t.isIncome == (_selectedCategory == 'Income') &&
                        (_selectedItem == 'All' ||
                            _selectedItem == null ||
                            t.category == _selectedItem))
                        .length,
                    itemBuilder: (context, index) {
                      final filteredTransactions = transactions
                          .where((t) =>
                      t.isIncome == (_selectedCategory == 'Income') &&
                          (_selectedItem == 'All' ||
                              _selectedItem == null ||
                              t.category == _selectedItem))
                          .toList();
                      final transaction = filteredTransactions[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              transaction.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                color: TColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              transaction.category,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            trailing: Text(
                              '₹${transaction.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: transaction.isIncome
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                          ),
                          if (index < filteredTransactions.length - 1)
                            Divider(
                              color: Colors.grey[300],
                              height: 1,
                              thickness: 1,
                              indent: 16,
                              endIndent: 16,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}