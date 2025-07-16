import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants/colors.dart';

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  String _selectedTheme = 'System';
  String _selectedCurrency = 'INR (₹)';
  String _selectedLanguage = 'English';
  String _defaultExpenseCategory = 'Other';
  String _defaultIncomeCategory = 'Salary';
  bool _showDecimalPlaces = true;

  final List<String> _themes = ['Light', 'Dark', 'System'];
  final List<String> _currencies = [
    'INR (₹)',
    'USD (\$)',
    'EUR (€)',
    'GBP (£)',
    'JPY (¥)',
    'CAD (C\$)',
    'AUD (A\$)',
    'CHF (Fr)',
    'CNY (¥)',
    'KRW (₩)'
  ];
  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese'
  ];
  final List<String> _expenseCategories = [
    'Groceries',
    'Utilities',
    'Rent',
    'Entertainment',
    'Transportation',
    'Healthcare',
    'Education',
    'Other'
  ];
  final List<String> _incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Business',
    'Gift',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        backgroundColor: TColors.primary,
        foregroundColor: TColors.textWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Appearance'),
            _buildDropdownTile(
              'Theme',
              _selectedTheme,
              _themes,
              FontAwesomeIcons.palette,
              (value) => setState(() => _selectedTheme = value!),
            ),
            _buildDropdownTile(
              'Language',
              _selectedLanguage,
              _languages,
              FontAwesomeIcons.language,
              (value) => setState(() => _selectedLanguage = value!),
            ),
            const SizedBox(height: 20),

            _buildSectionHeader('Currency & Format'),
            _buildDropdownTile(
              'Currency',
              _selectedCurrency,
              _currencies,
              FontAwesomeIcons.dollarSign,
              (value) => setState(() => _selectedCurrency = value!),
            ),
            _buildSwitchTile(
              'Show Decimal Places',
              'Display amounts with decimal precision',
              _showDecimalPlaces,
              FontAwesomeIcons.calculator,
              (value) => setState(() => _showDecimalPlaces = value),
            ),
            const SizedBox(height: 20),

            _buildSectionHeader('Default Categories'),
            _buildDropdownTile(
              'Default Expense Category',
              _defaultExpenseCategory,
              _expenseCategories,
              FontAwesomeIcons.minus,
              (value) => setState(() => _defaultExpenseCategory = value!),
            ),
            _buildDropdownTile(
              'Default Income Category',
              _defaultIncomeCategory,
              _incomeCategories,
              FontAwesomeIcons.plus,
              (value) => setState(() => _defaultIncomeCategory = value!),
            ),
            const SizedBox(height: 16),

            // Save button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: TColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _savePreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: TColors.textWhite,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save Preferences',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: 40,
            decoration: BoxDecoration(
              color: TColors.primary,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String selectedValue,
    List<String> options,
    IconData icon,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColors.containerPrimary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: TColors.containerPrimary.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: TColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(
            icon,
            size: 20,
            color: TColors.primary,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: TColors.containerSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: TColors.containerSecondary),
                ),
                child: DropdownButton<String>(
                  value: selectedValue,
                  onChanged: onChanged,
                  underline: const SizedBox(),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: options.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    IconData icon,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColors.containerPrimary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: TColors.containerPrimary.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: TColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(
            icon,
            size: 20,
            color: TColors.primary,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: TColors.textSecondary,
              ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: TColors.primary,
      ),
    );
  }

  void _savePreferences() {
    // Here you would typically save to SharedPreferences or your backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Preferences saved successfully!'),
        backgroundColor: TColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
