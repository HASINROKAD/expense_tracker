import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // General notification settings
  bool _enableNotifications = true;
  bool _enablePushNotifications = true;

  // Expense tracking notifications
  bool _enableExpenseReminders = true;

  bool _enableOverspendingWarnings = true;
  bool _enableCategoryLimitAlerts = false;

  // Summary notifications
  bool _enableDailySummary = false;
  bool _enableWeeklySummary = true;
  bool _enableMonthlySummary = true;

  // Timing settings
  String _dailySummaryTime = '8:00 PM';
  String _weeklySummaryDay = 'Sunday';
  String _monthlySummaryDay = '1st';

  final List<String> _timeOptions = [
    '6:00 AM',
    '7:00 AM',
    '8:00 AM',
    '9:00 AM',
    '6:00 PM',
    '7:00 PM',
    '8:00 PM',
    '9:00 PM',
    '10:00 PM'
  ];

  final List<String> _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<String> _monthDays = [
    '1st',
    '2nd',
    '3rd',
    '4th',
    '5th',
    '15th',
    '20th',
    '25th',
    'Last day'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? TColors.backgroundDark
          : Colors.grey[50],
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? TColors.primaryDark
            : TColors.primary,
        foregroundColor: TColors.textWhite,
        elevation: Theme.of(context).brightness == Brightness.dark ? 8 : 4,
        shadowColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black54
            : Colors.grey.withValues(alpha: 0.3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('General Settings'),
            _buildSwitchTile(
              'Enable Notifications',
              'Allow the app to send notifications',
              _enableNotifications,
              FontAwesomeIcons.bell,
              (value) => setState(() => _enableNotifications = value),
            ),
            _buildSwitchTile(
              'Push Notifications',
              'Receive notifications on your device',
              _enablePushNotifications,
              FontAwesomeIcons.mobile,
              (value) => setState(() => _enablePushNotifications = value),
              enabled: _enableNotifications,
            ),

            const SizedBox(height: 24),

            _buildSectionHeader('Expense Tracking'),
            _buildSwitchTile(
              'Expense Reminders',
              'Remind you to log daily expenses',
              _enableExpenseReminders,
              FontAwesomeIcons.clockRotateLeft,
              (value) => setState(() => _enableExpenseReminders = value),
              enabled: _enableNotifications,
            ),

            _buildSwitchTile(
              'Overspending Warnings',
              'Warn when exceeding budget',
              _enableOverspendingWarnings,
              FontAwesomeIcons.triangleExclamation,
              (value) => setState(() => _enableOverspendingWarnings = value),
              enabled: _enableNotifications,
            ),
            _buildSwitchTile(
              'Category Limit Alerts',
              'Alert for individual category limits',
              _enableCategoryLimitAlerts,
              FontAwesomeIcons.tags,
              (value) => setState(() => _enableCategoryLimitAlerts = value),
              enabled: _enableNotifications,
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Summary Reports'),
            _buildSwitchTile(
              'Daily Summary',
              'Daily expense and income summary',
              _enableDailySummary,
              FontAwesomeIcons.calendarDay,
              (value) => setState(() => _enableDailySummary = value),
              enabled: _enableNotifications,
            ),
            if (_enableDailySummary)
              _buildDropdownTile(
                'Daily Summary Time',
                _dailySummaryTime,
                _timeOptions,
                FontAwesomeIcons.clock,
                (value) => setState(() => _dailySummaryTime = value!),
              ),
            _buildSwitchTile(
              'Weekly Summary',
              'Weekly financial overview',
              _enableWeeklySummary,
              FontAwesomeIcons.calendarWeek,
              (value) => setState(() => _enableWeeklySummary = value),
              enabled: _enableNotifications,
            ),
            if (_enableWeeklySummary)
              _buildDropdownTile(
                'Weekly Summary Day',
                _weeklySummaryDay,
                _weekDays,
                FontAwesomeIcons.calendar,
                (value) => setState(() => _weeklySummaryDay = value!),
              ),
            _buildSwitchTile(
              'Monthly Summary',
              'Monthly financial report',
              _enableMonthlySummary,
              FontAwesomeIcons.calendarDays,
              (value) => setState(() => _enableMonthlySummary = value),
              enabled: _enableNotifications,
            ),
            if (_enableMonthlySummary)
              _buildDropdownTile(
                'Monthly Summary Day',
                _monthlySummaryDay,
                _monthDays,
                FontAwesomeIcons.calendarCheck,
                (value) => setState(() => _monthlySummaryDay = value!),
              ),
            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveNotificationSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: TColors.textWhite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Notifications',
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
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color.fromARGB(255, 53, 111, 111)
                      : TColors.primary,
                ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [
                        TColors.primaryDark,
                        TColors.primaryDark.withValues(alpha: 0.5),
                      ]
                    : [
                        TColors.primary,
                        TColors.primary.withValues(alpha: 0.5),
                      ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    IconData icon,
    ValueChanged<bool> onChanged, {
    bool enabled = true,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: Theme.of(context).brightness == Brightness.dark ? 6 : 3,
      shadowColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black54
          : Colors.grey.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Theme.of(context).brightness == Brightness.dark
          ? TColors.surfaceDark
          : Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: enabled
              ? null
              : Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[300]!,
                  width: 1,
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: enabled
                      ? (Theme.of(context).brightness == Brightness.dark
                          ? TColors.primaryDark.withValues(alpha: 0.2)
                          : TColors.primary.withValues(alpha: 0.1))
                      : (Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[700]!.withValues(alpha: 0.3)
                          : Colors.grey[300]!.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: enabled
                        ? (Theme.of(context).brightness == Brightness.dark
                            ? TColors.primaryDark.withValues(alpha: 0.3)
                            : TColors.primary.withValues(alpha: 0.2))
                        : (Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[600]!
                            : Colors.grey[400]!),
                    width: 1,
                  ),
                ),
                child: FaIcon(
                  icon,
                  size: 20,
                  color: enabled
                      ? (Theme.of(context).brightness == Brightness.dark
                          ? TColors.textWhite
                          : TColors.primary)
                      : (Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[500]
                          : Colors.grey[500]),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: enabled
                                ? (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? TColors.textPrimaryDark
                                    : TColors.textPrimary)
                                : (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[500]
                                    : Colors.grey[500]),
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: enabled
                                ? (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? TColors.textSecondaryDark
                                    : Colors.grey[600])
                                : (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[600]
                                    : Colors.grey[400]),
                          ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: enabled ? value : false,
                onChanged: enabled ? onChanged : null,
                activeColor: Theme.of(context).brightness == Brightness.dark
                    ? TColors.primaryDark
                    : TColors.primary,
                activeTrackColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? TColors.primaryDark.withValues(alpha: 0.3)
                        : TColors.primary.withValues(alpha: 0.3),
                inactiveThumbColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey[600],
                inactiveTrackColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[700]
                        : Colors.grey[400],
              ),
            ],
          ),
        ),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12, left: 20),
      elevation: Theme.of(context).brightness == Brightness.dark ? 4 : 2,
      shadowColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black54
          : Colors.grey.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Theme.of(context).brightness == Brightness.dark
          ? TColors.containerPrimaryDark
          : Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? TColors.primaryDark.withValues(alpha: 0.2)
                    : TColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? TColors.primaryDark.withValues(alpha: 0.3)
                      : TColors.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: FaIcon(
                icon,
                size: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? TColors.textWhite
                    : TColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? TColors.textPrimaryDark
                          : TColors.textPrimary,
                    ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? TColors.surfaceDark
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? TColors.borderDark.withValues(alpha: 0.3)
                        : Colors.grey.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: DropdownButton<String>(
                  value: selectedValue,
                  onChanged: onChanged,
                  underline: const SizedBox(),
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? TColors.textWhite
                        : Colors.grey[600],
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? TColors.textPrimaryDark
                            : TColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                  dropdownColor: Theme.of(context).brightness == Brightness.dark
                      ? TColors.surfaceDark
                      : Colors.white,
                  items: options.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? TColors.textPrimaryDark
                                  : TColors.textPrimary,
                            ),
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

  void _saveNotificationSettings() {
    // Here you would typically save to SharedPreferences or your backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification settings saved successfully!'),
        backgroundColor: TColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
