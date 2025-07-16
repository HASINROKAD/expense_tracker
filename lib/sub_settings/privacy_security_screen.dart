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
      appBar: AppBar(
        title: const Text('Privacy & Security'),
        backgroundColor: TColors.primary,
        foregroundColor: TColors.textWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
              FontAwesomeIcons.fileExport,
              (value) => setState(() => _requireAuthForExport = value),
            ),
            _buildSwitchTile(
              'Require Auth for Delete',
              'Require authentication to delete data',
              _requireAuthForDelete,
              FontAwesomeIcons.trash,
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
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: TColors.containerPrimary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColors.containerPrimary),
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

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(
            icon,
            size: 20,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: TColors.textSecondary,
              ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: color,
        ),
        onTap: onTap,
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
