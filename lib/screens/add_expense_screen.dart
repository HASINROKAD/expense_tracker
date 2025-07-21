import 'package:flutter/material.dart';
import 'package:expense_tracker/data/payment_category.dart';
import 'package:expense_tracker/widgets/date_picker.dart';
import '../data/supabase_auth.dart';
import '../utils/constants/colors.dart';
import '../validators/custom_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  AddExpenseScreenState createState() => AddExpenseScreenState();
}

class AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController payerController = TextEditingController();
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final List<String> _categories = [
    'Groceries',
    'Utilities',
    'Rent',
    'Entertainment',
    'Other',
  ];

  String? _selectedCategory;
  String? _selectedPaymentMethod;
  String? _selectedPaymentStatus;
  DateTime? _selectedDate;

  Future<void> _insertData() async {
    final client = SupabaseAuth.client();
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: You must be logged in to add expense.'),
          backgroundColor: TColors.errorPrimary,
        ),
      );
      return;
    }

    final formattedDate =
        _selectedDate != null ? _selectedDate! : DateTime.now();

    try {
      final response = await supabase.from('tbl_add_expense_data').insert({
        'user_uuid': userId,
        'expense_amount': double.tryParse(amountController.text.trim()) ?? 0.0,
        'payers_name': payerController.text.trim(),
        'expense_category': _selectedCategory,
        'expense_payment_method': _selectedPaymentMethod,
        'expense_payment_status': _selectedPaymentStatus,
        'expense_date': formattedDate.toIso8601String(),
      }).select();

      if (response.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Expense added successfully!'),
              backgroundColor: TColors.primary,
            ),
          );
          amountController.clear();
          payerController.clear();
          setState(() {
            _selectedCategory = null;
            _selectedPaymentMethod = null;
            _selectedPaymentStatus = null;
            _selectedDate = null;
          });
          Navigator.pop(context);
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: Failed to add expense. $error',
              style: const TextStyle(color: TColors.errorPrimary),
            ),
            backgroundColor: TColors.primary,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? TColors.primaryDark
            : TColors.primary,
        foregroundColor: TColors.textWhite,
        title: Text(
          'Add Expense',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: TColors.textWhite,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter the amount of the expense',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Example: 1000',
                    hintStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? TColors.hintTextDark
                          : TColors.hintTextLight,
                    ),
                  ),
                  validator: validateAmount,
                ),
                const SizedBox(height: 16),
                Text(
                  'Specify who paid for the expense',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: payerController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Payer's name",
                    hintStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? TColors.hintTextDark
                          : TColors.hintTextLight,
                    ),
                  ),
                  validator: validatePayer,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Category',
                  ),
                  value: _selectedCategory,
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  hint: const Text('Select a category'),
                  validator: validateCategory,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Payment Method',
                        ),
                        value: _selectedPaymentMethod,
                        items: paymentMethods.map((String method) {
                          return DropdownMenuItem<String>(
                            value: method,
                            child: Text(method),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPaymentMethod = newValue;
                          });
                        },
                        hint: Text(
                          'payment method',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        validator: validatePaymentMethod,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Payment Status',
                        ),
                        value: _selectedPaymentStatus,
                        items: paymentStatus.map((String method) {
                          return DropdownMenuItem<String>(
                            value: method,
                            child: Text(method),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPaymentStatus = newValue;
                          });
                        },
                        hint: Text(
                          'payment status',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        validator: validatePaymentStatus,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DatePicker(
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(), // Restrict to current date
                  labelText: 'Date',
                  onDateSelected: (DateTime date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
                if (validateDate(_selectedDate) != null &&
                    _formKey.currentState?.validate() == false)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      validateDate(_selectedDate)!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? TColors.primaryDark
                              : TColors.primary,
                      minimumSize: const Size(180, 48),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _insertData();
                      }
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    payerController.dispose();
    super.dispose();
  }
}
