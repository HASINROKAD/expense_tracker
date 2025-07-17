import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants/colors.dart';
import '../utils/theme_utils.dart';
import '../data/local_data_manager.dart';
import '../theme/theme_manager.dart';
import '../widgets/theme_preview_widget.dart';

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  final LocalDataManager _dataManager = LocalDataManager();
  final ThemeManager _themeManager = ThemeManager();
  bool _isLoading = true;
  bool _isSaving = false;

  // Current preference values
  String _selectedTheme = 'System';
  String _selectedCurrency = 'INR (₹)';
  String _selectedLanguage = 'English';
  String _defaultExpenseCategory = 'Other';
  String _defaultIncomeCategory = 'Salary';
  bool _showDecimalPlaces = true;

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
  void initState() {
    super.initState();
    _dataManager.addListener(_onDataChanged);
    _loadPreferences();
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

  Future<void> _onThemeChanged(String newTheme) async {
    setState(() {
      _selectedTheme = newTheme;
    });

    try {
      // Apply theme immediately through theme manager
      final themeValue = _getThemeValue(newTheme);
      await _themeManager.setTheme(themeValue);
    } catch (error) {
      // If theme manager fails, still update local state
      // The save button will handle the full preference save
    }
  }

  Future<void> _loadPreferences() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _dataManager.initialize();
      final preferences = _dataManager.userPreferences;

      if (preferences != null && mounted) {
        setState(() {
          _selectedTheme = _getThemeDisplayName(preferences.theme);
          _selectedCurrency = _getCurrencyDisplayName(preferences.currency);
          _selectedLanguage = _getLanguageDisplayName(preferences.language);
          _defaultExpenseCategory =
              preferences.defaultExpenseCategory ?? 'Other';
          _defaultIncomeCategory =
              preferences.defaultIncomeCategory ?? 'Salary';
          _showDecimalPlaces = preferences.showDecimalPlaces;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading preferences: $error'),
            backgroundColor: TColors.errorPrimary,
          ),
        );
      }
    }
  }

  String _getThemeDisplayName(String theme) {
    switch (theme.toLowerCase()) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      case 'system':
        return 'System';
      default:
        return 'System';
    }
  }

  String _getCurrencyDisplayName(String currency) {
    switch (currency.toUpperCase()) {
      case 'INR':
        return 'INR (₹)';
      case 'USD':
        return 'USD (\$)';
      case 'EUR':
        return 'EUR (€)';
      case 'GBP':
        return 'GBP (£)';
      case 'JPY':
        return 'JPY (¥)';
      case 'CAD':
        return 'CAD (C\$)';
      case 'AUD':
        return 'AUD (A\$)';
      case 'CHF':
        return 'CHF (Fr)';
      case 'CNY':
        return 'CNY (¥)';
      case 'KRW':
        return 'KRW (₩)';
      default:
        return 'INR (₹)';
    }
  }

  String _getLanguageDisplayName(String language) {
    switch (language.toLowerCase()) {
      case 'english':
        return 'English';
      case 'spanish':
        return 'Spanish';
      case 'french':
        return 'French';
      case 'german':
        return 'German';
      case 'chinese':
        return 'Chinese';
      case 'japanese':
        return 'Japanese';
      default:
        return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        backgroundColor: TColors.primary,
        foregroundColor: TColors.textWhite,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Appearance'),
                  ThemePreviewWidget(
                    currentTheme: _selectedTheme,
                    onThemeSelected: _onThemeChanged,
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
                      onPressed: _isSaving ? null : _savePreferences,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        foregroundColor: TColors.textWhite,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    TColors.textWhite),
                              ),
                            )
                          : const Text(
                              'Save Preferences',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
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
      decoration: ThemeUtils.getContainerDecoration(context),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ThemeUtils.getPrimaryColor(context).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(
            icon,
            size: 20,
            color: ThemeUtils.getPrimaryColor(context),
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
                  color: ThemeUtils.getContainerColor(context, elevated: true),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ThemeUtils.getBorderColor(context)),
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
      decoration: ThemeUtils.getContainerDecoration(context),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ThemeUtils.getPrimaryColor(context).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(
            icon,
            size: 20,
            color: ThemeUtils.getPrimaryColor(context),
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
                color: ThemeUtils.getTextColor(context,
                    importance: TextImportance.secondary),
              ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: ThemeUtils.getPrimaryColor(context),
      ),
    );
  }

  Future<void> _savePreferences() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final currentPreferences = _dataManager.userPreferences;
      if (currentPreferences == null) {
        throw Exception('No user preferences found');
      }

      // Convert display names back to internal values
      final themeValue = _getThemeValue(_selectedTheme);
      final currencyValue = _getCurrencyValue(_selectedCurrency);
      final languageValue = _getLanguageValue(_selectedLanguage);

      final updatedPreferences = currentPreferences.copyWith(
        theme: themeValue,
        currency: currencyValue,
        language: languageValue,
        defaultExpenseCategory: _defaultExpenseCategory,
        defaultIncomeCategory: _defaultIncomeCategory,
        showDecimalPlaces: _showDecimalPlaces,
      );

      await _dataManager.updateUserPreferences(updatedPreferences);

      if (mounted) {
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
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving preferences: $error'),
            backgroundColor: TColors.errorPrimary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String _getThemeValue(String displayName) {
    switch (displayName) {
      case 'Light':
        return 'light';
      case 'Dark':
        return 'dark';
      case 'System':
        return 'system';
      default:
        return 'system';
    }
  }

  String _getCurrencyValue(String displayName) {
    if (displayName.startsWith('INR')) return 'INR';
    if (displayName.startsWith('USD')) return 'USD';
    if (displayName.startsWith('EUR')) return 'EUR';
    if (displayName.startsWith('GBP')) return 'GBP';
    if (displayName.startsWith('JPY')) return 'JPY';
    if (displayName.startsWith('CAD')) return 'CAD';
    if (displayName.startsWith('AUD')) return 'AUD';
    if (displayName.startsWith('CHF')) return 'CHF';
    if (displayName.startsWith('CNY')) return 'CNY';
    if (displayName.startsWith('KRW')) return 'KRW';
    return 'INR';
  }

  String _getLanguageValue(String displayName) {
    switch (displayName) {
      case 'English':
        return 'en';
      case 'Spanish':
        return 'es';
      case 'French':
        return 'fr';
      case 'German':
        return 'de';
      case 'Chinese':
        return 'zh';
      case 'Japanese':
        return 'ja';
      default:
        return 'en';
    }
  }
}
