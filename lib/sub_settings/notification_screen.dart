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
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: TColors.primary,
        foregroundColor: TColors.textWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
              FontAwesomeIcons.exclamation,
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
            const SizedBox(height: 32),

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
                  'Save Notification Settings',
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: TColors.primary,
            ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: enabled
            ? TColors.containerPrimary.withValues(alpha: 0.3)
            : TColors.containerPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled
              ? TColors.containerPrimary
              : TColors.containerPrimary.withValues(alpha: 0.5),
        ),
      ),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: enabled
                ? TColors.primary.withValues(alpha: 0.1)
                : TColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(
            icon,
            size: 20,
            color: enabled
                ? TColors.primary
                : TColors.primary.withValues(alpha: 0.5),
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: enabled ? null : TColors.textSecondary,
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: enabled
                    ? TColors.textSecondary
                    : TColors.textSecondary.withValues(alpha: 0.7),
              ),
        ),
        value: enabled ? value : false,
        onChanged: enabled ? onChanged : null,
        activeColor: TColors.primary,
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
      margin: const EdgeInsets.only(bottom: 12, left: 16),
      decoration: BoxDecoration(
        color: TColors.containerSecondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColors.containerSecondary),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: TColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(
            icon,
            size: 18,
            color: TColors.secondary,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        trailing: DropdownButton<String>(
          value: selectedValue,
          onChanged: onChanged,
          underline: const SizedBox(),
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
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
