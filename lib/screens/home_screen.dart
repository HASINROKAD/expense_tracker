import 'package:flutter/material.dart';
import '../data/local_data_manager.dart';
import '../utils/constants/colors.dart';
import 'package:expense_tracker/widgets/dynamic_text_row.dart';
import 'package:expense_tracker/theme/custom_theme/dropdown_button_theme.dart';
import 'package:expense_tracker/widgets/scrollable_row_card_widget.dart';

// Import Transaction from LocalDataManager
// (Transaction model is now in local_data_manager.dart)

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalDataManager _dataManager = LocalDataManager();
  bool _isLoading = true;

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
    // Initialize data manager and listen to changes
    _initializeData();
    _dataManager.addListener(_onDataChanged);
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

  @override
  void dispose() {
    _dataManager.removeListener(_onDataChanged);
    _scrollController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {
        _isLoading = _dataManager.isLoading;
        _updateDropdownItems();
      });
    }
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _dataManager.initialize();
      _updateDropdownItems();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong, Try Again'),
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

  void _updateDropdownItems() {
    final metrics = _dataManager.metrics;
    if (metrics != null) {
      _items = ['All', ...metrics.expenseCategories.keys];
      _selectedItem = _items.isNotEmpty ? _items.first : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _dataManager.metrics;
    final double balance = metrics?.currentBalance ?? 0.0;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color.fromARGB(255, 53, 111, 111)
                                  : TColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                      DynamicTextRow(
                        label: 'Total Income:',
                        value: (metrics?.totalIncome ?? 0.0).toStringAsFixed(2),
                        valueColor: Colors.green,
                      ),
                      DynamicTextRow(
                        label: 'Total Expenses:',
                        value:
                            (metrics?.totalExpenses ?? 0.0).toStringAsFixed(2),
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
                            'Loading...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? TColors.primaryDark
                                  : TColors.primary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ScrollableRowCardWidget(
                      scrollController: _scrollController,
                      currentBalance: metrics?.currentBalance ?? 0.0,
                      endOfMonthBalance: metrics?.currentBalance ?? 0.0,
                      thisWeekBalance: metrics?.thisWeekBalance ?? 0.0,
                      thisMonthBalance: metrics?.thisMonthBalance ?? 0.0,
                      thisWeekIncome: metrics?.thisWeekIncome ?? 0.0,
                      thisMonthIncome: metrics?.thisMonthIncome ?? 0.0,
                      yearToDateIncome: metrics?.yearToDateIncome ?? 0.0,
                      thisWeekExpense: metrics?.thisWeekExpense ?? 0.0,
                      thisMonthExpense: metrics?.thisMonthExpense ?? 0.0,
                      yearToDateExpense: metrics?.yearToDateExpense ?? 0.0,
                      todayExpense: metrics?.todayExpense ?? 0.0,
                    ),

              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? TColors.containerPrimaryDark
                              : TColors.containerPrimary,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? TColors.borderDark
                                    : TColors.containerSecondary,
                          ),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          dropdownColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? TColors.surfaceDark
                                  : TColors.containerSecondary,
                          menuMaxHeight: 200,
                          underline: Container(),
                          borderRadius: BorderRadius.circular(10.0),
                          elevation: 2,
                          style:
                              DropdownStyle.getDropdownMenuItemStyle().copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? TColors.textPrimaryDark
                                    : TColors.textPrimary,
                          ),
                          value: _selectedItem,
                          items: _items.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: DropdownStyle.getDropdownMenuItemStyle()
                                    .copyWith(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? TColors.textPrimaryDark
                                      : TColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedItem = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: SegmentedButton<String>(
                        style: SegmentedButton.styleFrom(
                          selectedBackgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? TColors.primaryDark
                                  : TColors.containerSecondary,
                          selectedForegroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? TColors.textWhite
                                  : TColors.textPrimary,
                          foregroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? TColors.textSecondaryDark
                                  : TColors.textSecondary,
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? TColors.containerPrimaryDark
                                  : Colors.grey[100],
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
                            final metrics = _dataManager.metrics;
                            _items = _selectedCategory == 'Income'
                                ? [
                                    'All',
                                    ...(metrics?.incomeCategories.keys ?? [])
                                  ]
                                : [
                                    'All',
                                    ...(metrics?.expenseCategories.keys ?? [])
                                  ];
                            _selectedItem =
                                _items.isNotEmpty ? _items.first : null;
                          });
                        },
                      ),
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
                    itemCount: _dataManager.transactions
                        .where((t) =>
                            t.isIncome == (_selectedCategory == 'Income') &&
                            (_selectedItem == 'All' ||
                                _selectedItem == null ||
                                t.category == _selectedItem))
                        .length,
                    itemBuilder: (context, index) {
                      final filteredTransactions = _dataManager.transactions
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
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? TColors.textPrimaryDark
                                        : TColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            subtitle: Text(
                              transaction.category,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? TColors.textSecondaryDark
                                        : Colors.grey[600],
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? TColors.dividerDark
                                  : Colors.grey[300],
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
