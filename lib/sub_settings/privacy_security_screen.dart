import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants/colors.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  // Authentication settings
  bool _enablePinLock = false;

  // Privacy settings
  bool _shareAnalytics = false;
  bool _shareUsageData = false;
  bool _enableLocationTracking = false;

  // Security features
  bool _enableFailedLoginAlert = true;
  bool _enableDeviceChangeAlert = true;
  bool _enableSuspiciousActivityAlert = true;
  bool _requireAuthForExport = true;
  bool _requireAuthForDelete = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? TColors.backgroundDark
          : Colors.grey[50],
      appBar: AppBar(
        title: const Text('Privacy & Security'),
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
            _buildSectionHeader('Authentication'),

            _buildSwitchTile(
              'PIN Lock',
              'Require PIN to access the app',
              _enablePinLock,
              FontAwesomeIcons.lock,
              (value) => setState(() => _enablePinLock = value),
            ),
            const SizedBox(height: 16),

            _buildSectionHeader('Privacy Controls'),

            _buildSwitchTile(
              'Share Analytics',
              'Help improve the app with anonymous analytics',
              _shareAnalytics,
              FontAwesomeIcons.chartLine,
              (value) => setState(() => _shareAnalytics = value),
            ),
            _buildSwitchTile(
              'Share Usage Data',
              'Share app usage patterns for improvements',
              _shareUsageData,
              FontAwesomeIcons.chartBar,
              (value) => setState(() => _shareUsageData = value),
            ),
            _buildSwitchTile(
              'Location Tracking',
              'Track location for expense categorization',
              _enableLocationTracking,
              FontAwesomeIcons.locationDot,
              (value) => setState(() => _enableLocationTracking = value),
            ),
            const SizedBox(height: 16),

            _buildSectionHeader('Security Alerts'),
            _buildSwitchTile(
              'Failed Login Alerts',
              'Alert on multiple failed login attempts',
              _enableFailedLoginAlert,
              FontAwesomeIcons.triangleExclamation,
              (value) => setState(() => _enableFailedLoginAlert = value),
            ),
            _buildSwitchTile(
              'Device Change Alerts',
              'Alert when accessing from new device',
              _enableDeviceChangeAlert,
              FontAwesomeIcons.mobile,
              (value) => setState(() => _enableDeviceChangeAlert = value),
            ),
            _buildSwitchTile(
              'Suspicious Activity Alerts',
              'Alert on unusual account activity',
              _enableSuspiciousActivityAlert,
              FontAwesomeIcons.userShield,
              (value) => setState(() => _enableSuspiciousActivityAlert = value),
            ),
            const SizedBox(height: 16),

            _buildSectionHeader('Data Protection'),
            _buildSwitchTile(
              'Require Auth for Export',
              'Require authentication to export data',
              _requireAuthForExport,
              FontAwesomeIcons.download,
              (value) => setState(() => _requireAuthForExport = value),
            ),
            _buildSwitchTile(
              'Require Auth for Delete',
              'Require authentication to delete data',
              _requireAuthForDelete,
              FontAwesomeIcons.trashCan,
              (value) => setState(() => _requireAuthForDelete = value),
            ),
            const SizedBox(height: 16),

            _buildSectionHeader('Data Actions'),
            _buildActionTile(
              'Export Data',
              'Download all your data',
              FontAwesomeIcons.download,
              TColors.primary,
              _exportData,
            ),
            _buildActionTile(
              'View Privacy Policy',
              'Read our privacy policy',
              FontAwesomeIcons.fileContract,
              TColors.secondary,
              _viewPrivacyPolicy,
            ),
            _buildActionTile(
              'Delete All Data',
              'Permanently delete all your data',
              FontAwesomeIcons.trashCan,
              TColors.errorPrimary,
              _deleteAllData,
            ),
            const SizedBox(height: 20),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePrivacySettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: TColors.textWhite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Privacy & Security Settings',
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
    ValueChanged<bool> onChanged,
  ) {
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? TColors.primaryDark.withValues(alpha: 0.2)
                    : TColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? TColors.primaryDark.withValues(alpha: 0.3)
                      : TColors.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: FaIcon(
                icon,
                size: 20,
                color: Theme.of(context).brightness == Brightness.dark
                    ? TColors.textWhite
                    : TColors.primary,
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
                          color: Theme.of(context).brightness == Brightness.dark
                              ? TColors.textPrimaryDark
                              : TColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? TColors.textSecondaryDark
                              : Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Theme.of(context).brightness == Brightness.dark
                  ? TColors.primaryDark
                  : TColors.primary,
              activeTrackColor: Theme.of(context).brightness == Brightness.dark
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
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: FaIcon(
                  icon,
                  size: 20,
                  color: (icon == FontAwesomeIcons.trashCan &&
                          color == TColors.errorPrimary)
                      ? color // Keep delete icon red
                      : (Theme.of(context).brightness == Brightness.dark
                          ? TColors.textWhite
                          : color),
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
                            color: color,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? TColors.textSecondaryDark
                                    : Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: (icon == FontAwesomeIcons.trashCan &&
                        color == TColors.errorPrimary)
                    ? color // Keep delete chevron red
                    : (Theme.of(context).brightness == Brightness.dark
                        ? TColors.textWhite
                        : color),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'Your data will be exported as a CSV file. This may take a few moments.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement data export logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Data export started. You will be notified when complete.'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primary,
              foregroundColor: TColors.textWhite,
            ),
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _viewPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'This is where the privacy policy content would be displayed. '
            'In a real app, this would contain the full privacy policy text '
            'or open a web view to display the policy.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _deleteAllData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Data'),
        content: const Text(
          'This will permanently delete all your data including expenses, '
          'income, categories, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmDeleteAllData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.errorPrimary,
              foregroundColor: TColors.textWhite,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAllData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Final Confirmation'),
        content: const Text(
          'Are you absolutely sure? Type "DELETE" to confirm.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement data deletion logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data has been deleted.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.errorPrimary,
              foregroundColor: TColors.textWhite,
            ),
            child: const Text('Confirm Delete'),
          ),
        ],
      ),
    );
  }

  void _savePrivacySettings() {
    // Here you would typically save to SharedPreferences or your backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Privacy & security settings saved successfully!'),
        backgroundColor: TColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
