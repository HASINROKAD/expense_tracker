import 'package:flutter/material.dart';
import 'package:expense_tracker/data/payment_category.dart';
import 'package:expense_tracker/widgets/date_picker.dart';

import '../data/supabase_auth.dart';
import '../utils/constants/colors.dart';
import '../validators/custom_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  AddIncomeScreenState createState() => AddIncomeScreenState();
}

class AddIncomeScreenState extends State<AddIncomeScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController payeeController = TextEditingController();
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  // Predefined categories for the dropdown
  final List<String> _categories = [
    'Salary',
    'Freelance',
    'Investment',
    'Gift',
    'Other',
  ];

  // Variables to store selected values

  String? _selectedCategory;
  String? _selectedPaymentMethod;
  String? _selectedPaymentStatus;
  DateTime? _selectedDate;

  Future<void> _insertData() async {
    final client = SupabaseAuth.client();
    final userId = client.auth.currentUser?.id;
    final formattedDate =
        _selectedDate != null ? _selectedDate! : DateTime.now();

    try {
      final response = await supabase.from('tbl_add_income_data').insert({
        'user_uuid': userId,
        'income_amount': double.parse(amountController.text),
        'payees_name': payeeController.text.trim(),
        'income_category': _selectedCategory,
        'income_payment_method': _selectedPaymentMethod,
        'income_payment_status': _selectedPaymentStatus,
        'income_date': formattedDate.toIso8601String(),
      }).select();
      if (response.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Income added successfully!'),
              backgroundColor: TColors.primary,
            ),
          );
          // Clear form after successful insertion
          amountController.clear();
          payeeController.clear();
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
          const SnackBar(
            content: Text(
              'Sorry your data is not inserted,Try again',
              style: TextStyle(color: TColors.errorPrimary),
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
        backgroundColor: TColors.primary,
        foregroundColor: TColors.textWhite,
        title: Text(
          'Add Income',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: TColors.textWhite),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description for Income Amount
                Text(
                  'Enter the amount of income received',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                // Income Amount Form Field
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Example: 1000',
                    hintStyle: TextStyle(color: TColors.hintTextLight),
                  ),
                  validator: validateAmount,
                ),

                const SizedBox(height: 16),

                // Description for Payee
                Text(
                  'Specify the source or payer of the income',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                // Payee Form Field
                TextFormField(
                  controller: payeeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Payee's name",
                    hintStyle: TextStyle(color: TColors.hintTextLight),
                  ),
                  validator: validatePayee,
                ),

                const SizedBox(height: 16),

                // Category Dropdown
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
                    // Payment Method Dropdown
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

                    // Payment Status Dropdown
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
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  labelText: 'Date',
                  onDateSelected: (DateTime date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),

                // Display date validation error if applicable
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
                      backgroundColor: TColors.primary,
                      minimumSize: const Size(180, 48),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: _insertData,
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
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
    payeeController.dispose();
    super.dispose();
  }
}
