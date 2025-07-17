import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/payment_category.dart';
import '../data/supabase_auth.dart';
import '../data/local_data_manager.dart';
import '../utils/constants/colors.dart';
import '../validators/custom_validator.dart';
import '../widgets/date_picker.dart';

class EditAddScreenData extends StatefulWidget {
  final Transaction? transaction; // Transaction to edit, null for new
  final String transactionType; // 'income' or 'expense'

  const EditAddScreenData({
    super.key,
    this.transaction,
    required this.transactionType,
  });

  @override
  EditAddScreenDataState createState() => EditAddScreenDataState();
}

class EditAddScreenDataState extends State<EditAddScreenData> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController payerController = TextEditingController();
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  List<String> _paymentStatuses = [];
  String? _selectedPaymentStatus;
  DateTime? _selectedDate;
  bool _isLoading = true; // Tracks loading state for fetching payment statuses

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();

    if (widget.transaction != null) {
      amountController.text = widget.transaction!.amount.toString();
      payerController.text = widget.transaction!.title;
      _selectedDate = widget.transaction!.date;
    }
  }

  Future<void> _fetchDropdownData() async {
    setState(() {
      _isLoading = true;
    });

    final client = SupabaseAuth.client();
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: You must be logged in to fetch data.'),
          backgroundColor: TColors.errorPrimary,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Fetch payment statuses for expenses
      List<String> paymentStatuses = [];
      if (widget.transactionType == 'expense') {
        final expenseResponse = await supabase
            .from('tbl_add_expense_data')
            .select('expense_payment_status')
            .eq('user_uuid', userId);
        paymentStatuses = expenseResponse
            .map((record) => record['expense_payment_status']?.toString())
            .whereType<String>()
            .where((status) => status.isNotEmpty)
            .toSet()
            .toList();
        paymentStatuses.sort();
      }

      setState(() {
        _paymentStatuses = paymentStatuses.isNotEmpty
            ? paymentStatuses
            : paymentStatus; // Fallback to imported paymentStatus
        _isLoading = false;

        // Set selected payment status after fetching
        if (widget.transaction != null && widget.transactionType == 'expense') {
          _selectedPaymentStatus =
              _paymentStatuses.contains(widget.transaction!.category)
                  ? widget.transaction!.category
                  : null;
        }
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching dropdown data: $error'),
            backgroundColor: TColors.errorPrimary,
          ),
        );
      }
      setState(() {
        _isLoading = false;
        _paymentStatuses = paymentStatus; // Fallback to imported paymentStatus
      });
    }
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    final client = SupabaseAuth.client();
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: You must be logged in to save data.'),
          backgroundColor: TColors.errorPrimary,
        ),
      );
      return;
    }

    final formattedDate = _selectedDate != null
        ? _selectedDate!.toIso8601String()
        : DateTime.now().toIso8601String();

    try {
      final table = widget.transactionType == 'income'
          ? 'tbl_add_income_data'
          : 'tbl_add_expense_data';
      final data = {
        'user_uuid': userId,
        widget.transactionType == 'income' ? 'income_amount' : 'expense_amount':
            double.tryParse(amountController.text.trim()) ?? 0.0,
        widget.transactionType == 'income' ? 'payees_name' : 'payers_name':
            payerController.text.trim(),
        if (widget.transactionType == 'expense') ...{
          'expense_payment_status': _selectedPaymentStatus,
        },
        widget.transactionType == 'income' ? 'income_date' : 'expense_date':
            formattedDate,
      };

      if (widget.transaction != null) {
        await supabase
            .from(table)
            .update(data)
            .eq('id', widget.transaction!.id);
      } else {
        await supabase.from(table).insert(data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${widget.transactionType == 'income' ? 'Income' : 'Expense'} ${widget.transaction != null ? 'updated' : 'added'} successfully!'),
            backgroundColor: TColors.primary,
          ),
        );

        amountController.clear();
        payerController.clear();
        setState(() {
          _selectedPaymentStatus = null;
          _selectedDate = null;
        });
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: Failed to ${widget.transaction != null ? 'update' : 'add'} ${widget.transactionType}. $error',
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
        backgroundColor: TColors.primary,
        foregroundColor: TColors.textWhite,
        title: Text(
          widget.transaction != null
              ? 'Edit ${widget.transactionType == 'income' ? 'Income' : 'Expense'}'
              : 'Add ${widget.transactionType == 'income' ? 'Income' : 'Expense'}',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: TColors.textWhite),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(TColors.primary),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter the amount of the ${widget.transactionType}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 10),
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
                      Text(
                        'Specify who ${widget.transactionType == 'income' ? 'received' : 'paid for'} the ${widget.transactionType}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: payerController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: widget.transactionType == 'income'
                              ? "Payee's name"
                              : "Payer's name",
                          hintStyle:
                              const TextStyle(color: TColors.hintTextLight),
                        ),
                        validator: widget.transactionType == 'income'
                            ? validatePayee
                            : validatePayer,
                      ),
                      const SizedBox(height: 16),
                      DatePicker(
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100), // Allow future dates
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
                            backgroundColor: TColors.primary,
                            minimumSize: const Size(180, 48),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: _saveData,
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
    payerController.dispose();
    super.dispose();
  }
}
