import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants/colors.dart';

class BackupSyncScreen extends StatefulWidget {
  const BackupSyncScreen({super.key});

  @override
  State<BackupSyncScreen> createState() => _BackupSyncScreenState();
}

class _BackupSyncScreenState extends State<BackupSyncScreen> {
  // Backup settings
  bool _autoBackupEnabled = true;
  String _backupFrequency = 'Daily';
  String _backupTime = '2:00 AM';
  bool _backupOnWiFiOnly = true;
  bool _includeImages = true;
  bool _compressBackups = true;

  // Cloud sync settings
  bool _cloudSyncEnabled = true;
  String _cloudProvider = 'Google Drive';
  bool _syncOnWiFiOnly = true;
  bool _realTimeSync = false;
  String _lastSyncTime = '2 hours ago';

  // Backup status
  String _lastBackupDate = 'March 10, 2024';
  String _lastBackupSize = '2.4 MB';
  bool _backupInProgress = false;
  double _backupProgress = 0.0;

  final List<String> _backupFrequencies = [
    'Real-time',
    'Every hour',
    'Every 6 hours',
    'Daily',
    'Weekly',
    'Monthly',
    'Manual only'
  ];

  final List<String> _backupTimes = [
    '12:00 AM',
    '1:00 AM',
    '2:00 AM',
    '3:00 AM',
    '4:00 AM',
    '5:00 AM',
    '6:00 AM'
  ];

  final List<String> _cloudProviders = [
    'Google Drive',
    'iCloud',
    'Dropbox',
    'OneDrive',
    'Local only'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Sync'),
        backgroundColor: TColors.primary,
        foregroundColor: TColors.textWhite,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.cloudArrowUp),
            onPressed: _manualBackup,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Backup Status Card
            _buildBackupStatusCard(),
            const SizedBox(height: 24),

            // Auto Backup Settings
            _buildSectionHeader('Auto Backup'),
            _buildSwitchTile(
              'Enable Auto Backup',
              'Automatically backup your data',
              _autoBackupEnabled,
              FontAwesomeIcons.clockRotateLeft,
              (value) => setState(() => _autoBackupEnabled = value),
            ),
            if (_autoBackupEnabled) ...[
              _buildDropdownTile(
                'Backup Frequency',
                _backupFrequency,
                _backupFrequencies,
                FontAwesomeIcons.calendar,
                (value) => setState(() => _backupFrequency = value!),
              ),
              if (_backupFrequency == 'Daily')
                _buildDropdownTile(
                  'Backup Time',
                  _backupTime,
                  _backupTimes,
                  FontAwesomeIcons.clock,
                  (value) => setState(() => _backupTime = value!),
                ),
              _buildSwitchTile(
                'WiFi Only',
                'Only backup when connected to WiFi',
                _backupOnWiFiOnly,
                FontAwesomeIcons.wifi,
                (value) => setState(() => _backupOnWiFiOnly = value),
              ),
            ],
            const SizedBox(height: 24),

            // Cloud Sync Settings
            _buildSectionHeader('Cloud Sync'),
            _buildSwitchTile(
              'Enable Cloud Sync',
              'Sync data across devices',
              _cloudSyncEnabled,
              FontAwesomeIcons.cloud,
              (value) => setState(() => _cloudSyncEnabled = value),
            ),
            if (_cloudSyncEnabled) ...[
              _buildDropdownTile(
                'Cloud Provider',
                _cloudProvider,
                _cloudProviders,
                FontAwesomeIcons.server,
                (value) => setState(() => _cloudProvider = value!),
              ),
              _buildSwitchTile(
                'Real-time Sync',
                'Sync changes immediately',
                _realTimeSync,
                FontAwesomeIcons.bolt,
                (value) => setState(() => _realTimeSync = value),
              ),
              _buildSwitchTile(
                'Sync on WiFi Only',
                'Only sync when connected to WiFi',
                _syncOnWiFiOnly,
                FontAwesomeIcons.wifi,
                (value) => setState(() => _syncOnWiFiOnly = value),
              ),
              _buildInfoTile(
                'Last Sync',
                _lastSyncTime,
                FontAwesomeIcons.clockRotateLeft,
                TColors.primary,
              ),
            ],
            const SizedBox(height: 24),

            // Backup Options
            _buildSectionHeader('Backup Options'),
            _buildSwitchTile(
              'Include Images',
              'Backup receipt images and attachments',
              _includeImages,
              FontAwesomeIcons.image,
              (value) => setState(() => _includeImages = value),
            ),
            _buildSwitchTile(
              'Compress Backups',
              'Reduce backup size with compression',
              _compressBackups,
              FontAwesomeIcons.fileZipper,
              (value) => setState(() => _compressBackups = value),
            ),
            const SizedBox(height: 24),

            // Backup Actions
            _buildSectionHeader('Backup Actions'),
            _buildActionTile(
              'Manual Backup',
              'Create a backup now',
              FontAwesomeIcons.cloudArrowUp,
              TColors.primary,
              _manualBackup,
            ),
            _buildActionTile(
              'Restore from Backup',
              'Restore data from a previous backup',
              FontAwesomeIcons.cloudArrowDown,
              TColors.secondary,
              _restoreBackup,
            ),
            _buildActionTile(
              'Export Data',
              'Export data as CSV or JSON',
              FontAwesomeIcons.fileExport,
              TColors.tertiary,
              _exportData,
            ),
            _buildActionTile(
              'Import Data',
              'Import data from file',
              FontAwesomeIcons.fileImport,
              TColors.containerTertiary,
              _importData,
            ),
            _buildActionTile(
              'View Backup History',
              'See all previous backups',
              FontAwesomeIcons.clockRotateLeft,
              TColors.primary,
              _viewBackupHistory,
            ),
            _buildActionTile(
              'Delete All Backups',
              'Remove all backup files',
              FontAwesomeIcons.trash,
              TColors.errorPrimary,
              _deleteAllBackups,
            ),
            const SizedBox(height: 32),
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

  Widget _buildBackupStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TColors.primary, TColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TColors.textWhite.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FaIcon(
                  _backupInProgress
                      ? FontAwesomeIcons.spinner
                      : FontAwesomeIcons.cloudArrowUp,
                  color: TColors.textWhite,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _backupInProgress ? 'Backup in Progress' : 'Last Backup',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: TColors.textWhite,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      _backupInProgress
                          ? '${(_backupProgress * 100).toInt()}% complete'
                          : _lastBackupDate,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: TColors.textWhite.withValues(alpha: 0.9),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_backupInProgress) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _backupProgress,
              backgroundColor: TColors.textWhite.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(TColors.textWhite),
            ),
          ] else ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatusItem('Size', _lastBackupSize),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: TColors.textWhite.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: _buildStatusItem('Status', 'Complete'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: TColors.textWhite.withValues(alpha: 0.8),
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TColors.textWhite,
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
      ],
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

  Widget _buildInfoTile(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 16),
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
            size: 18,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
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

  // Action handlers
  void _manualBackup() {
    if (_backupInProgress) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup already in progress')),
      );
      return;
    }

    setState(() {
      _backupInProgress = true;
      _backupProgress = 0.0;
    });

    // Simulate backup progress
    _simulateBackupProgress();
  }

  void _simulateBackupProgress() async {
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() {
          _backupProgress = i / 100;
        });
      }
    }

    if (mounted) {
      setState(() {
        _backupInProgress = false;
        _lastBackupDate = 'Just now';
        _lastBackupSize = '2.6 MB';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Backup completed successfully!'),
          backgroundColor: TColors.primary,
        ),
      );
    }
  }

  void _restoreBackup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore from Backup'),
        content: const Text(
          'This will replace your current data with data from a backup. '
          'Your current data will be lost. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showRestoreOptions();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.secondary,
              foregroundColor: TColors.textWhite,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showRestoreOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Backup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.calendar),
              title: const Text('March 10, 2024'),
              subtitle: const Text('2.4 MB - Complete backup'),
              onTap: () {
                Navigator.pop(context);
                _performRestore('March 10, 2024');
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.calendar),
              title: const Text('March 9, 2024'),
              subtitle: const Text('2.3 MB - Complete backup'),
              onTap: () {
                Navigator.pop(context);
                _performRestore('March 9, 2024');
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.calendar),
              title: const Text('March 8, 2024'),
              subtitle: const Text('2.1 MB - Complete backup'),
              onTap: () {
                Navigator.pop(context);
                _performRestore('March 8, 2024');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _performRestore(String backupDate) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Restoring from backup: $backupDate'),
        backgroundColor: TColors.secondary,
      ),
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.fileCsv),
              title: const Text('Export as CSV'),
              subtitle: const Text('Spreadsheet format'),
              onTap: () {
                Navigator.pop(context);
                _performExport('CSV');
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.fileCode),
              title: const Text('Export as JSON'),
              subtitle: const Text('Raw data format'),
              onTap: () {
                Navigator.pop(context);
                _performExport('JSON');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _performExport(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting data as $format...'),
        backgroundColor: TColors.tertiary,
      ),
    );
  }

  void _importData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Data'),
        content: const Text(
          'Select a file to import. Supported formats: CSV, JSON',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('File picker would open here'),
                  backgroundColor: TColors.containerTertiary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.containerTertiary,
              foregroundColor: TColors.textWhite,
            ),
            child: const Text('Select File'),
          ),
        ],
      ),
    );
  }

  void _viewBackupHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup History'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildHistoryItem('March 10, 2024', '2.4 MB', 'Complete'),
              _buildHistoryItem('March 9, 2024', '2.3 MB', 'Complete'),
              _buildHistoryItem('March 8, 2024', '2.1 MB', 'Complete'),
              _buildHistoryItem('March 7, 2024', '2.0 MB', 'Complete'),
              _buildHistoryItem('March 6, 2024', '1.9 MB', 'Failed'),
            ],
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

  Widget _buildHistoryItem(String date, String size, String status) {
    Color statusColor =
        status == 'Complete' ? TColors.primary : TColors.errorPrimary;
    IconData statusIcon = status == 'Complete'
        ? FontAwesomeIcons.circleCheck
        : FontAwesomeIcons.circleXmark;

    return ListTile(
      leading: FaIcon(statusIcon, color: statusColor, size: 16),
      title: Text(date),
      subtitle: Text(size),
      trailing: Text(
        status,
        style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _deleteAllBackups() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Backups'),
        content: const Text(
          'This will permanently delete all backup files. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All backups deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.errorPrimary,
              foregroundColor: TColors.textWhite,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}
