import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants/colors.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // User profile data
  String _userName = 'John Doe';
  String _userEmail = 'john.doe@example.com';
  String _userPhone = '+1 (555) 123-4567';

  // Account settings
  bool _emailVerified = true;
  bool _phoneVerified = false;
  bool _twoFactorEnabled = false;

  // Multiple accounts
  List<Map<String, dynamic>> _userAccounts = [
    {
      'id': '1',
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'isActive': true,
      'avatar': null,
      'accountType': 'Personal',
    },
  ];

  // Statistics
  int _totalTransactions = 1247;
  int _categoriesCreated = 15;
  int _daysActive = 45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: TColors.primary,
        foregroundColor: TColors.textWhite,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.pen),
            onPressed: _editProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildProfileCard(),
            const SizedBox(height: 24),

            // Account Status
            _buildSectionHeader('Account Status'),
            _buildStatusTile(
              'Email Verification',
              _emailVerified ? 'Verified' : 'Not Verified',
              _emailVerified
                  ? FontAwesomeIcons.circleCheck
                  : FontAwesomeIcons.circleXmark,
              _emailVerified ? TColors.primary : TColors.errorPrimary,
              _emailVerified ? null : _verifyEmail,
            ),
            _buildStatusTile(
              'Phone Verification',
              _phoneVerified ? 'Verified' : 'Not Verified',
              _phoneVerified
                  ? FontAwesomeIcons.circleCheck
                  : FontAwesomeIcons.circleXmark,
              _phoneVerified ? TColors.primary : TColors.errorPrimary,
              _phoneVerified ? null : _verifyPhone,
            ),
            _buildStatusTile(
              'Two-Factor Authentication',
              _twoFactorEnabled ? 'Enabled' : 'Disabled',
              _twoFactorEnabled
                  ? FontAwesomeIcons.shield
                  : FontAwesomeIcons.shieldHalved,
              _twoFactorEnabled ? TColors.primary : TColors.errorPrimary,
              _toggle2FA,
            ),
            const SizedBox(height: 24),

            // Multiple Accounts
            _buildSectionHeader('Multiple Accounts'),
            _buildAccountsList(),
            const SizedBox(height: 16),
            _buildAddAccountButton(),
            const SizedBox(height: 24),

            // Account Statistics
            _buildSectionHeader('Account Statistics'),
            _buildStatsCard(),
            const SizedBox(height: 24),

            // Account Actions
            _buildSectionHeader('Account Actions'),
            _buildActionTile(
              'Change Password',
              'Update your account password',
              FontAwesomeIcons.key,
              TColors.primary,
              _changePassword,
            ),
            _buildActionTile(
              'Download Data',
              'Export all your account data',
              FontAwesomeIcons.download,
              TColors.secondary,
              _downloadData,
            ),

            _buildActionTile(
              'Delete Account',
              'Permanently delete your account',
              FontAwesomeIcons.trash,
              TColors.errorPrimary,
              _deleteAccount,
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

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TColors.primary, TColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main profile section
          Row(
            children: [
              // Enhanced avatar with status indicator
              Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: TColors.textWhite.withValues(alpha: 0.2),
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: TColors.textWhite,
                      child: FaIcon(
                        FontAwesomeIcons.user,
                        size: 35,
                        color: TColors.primary,
                      ),
                    ),
                  ),
                  // Verification status indicator
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _emailVerified ? Colors.green : Colors.orange,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: TColors.textWhite,
                          width: 2,
                        ),
                      ),
                      child: FaIcon(
                        _emailVerified
                            ? FontAwesomeIcons.check
                            : FontAwesomeIcons.exclamation,
                        size: 12,
                        color: TColors.textWhite,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              // User information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name with better typography
                    Text(
                      _userName,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: TColors.textWhite,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                    ),
                    const SizedBox(height: 8),
                    // Email with icon
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.envelope,
                          size: 14,
                          color: TColors.textWhite.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _userEmail,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color:
                                      TColors.textWhite.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_emailVerified)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.green.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              'Verified',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.green[100],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Phone with icon
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.phone,
                          size: 14,
                          color: TColors.textWhite.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _userPhone,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color:
                                      TColors.textWhite.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        if (_phoneVerified)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.green.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              'Verified',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.green[100],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Security status bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: TColors.textWhite.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TColors.textWhite.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.shield,
                  size: 16,
                  color: _twoFactorEnabled
                      ? Colors.green[300]
                      : Colors.orange[300],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _twoFactorEnabled
                        ? 'Account secured with 2FA'
                        : 'Enable 2FA for better security',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TColors.textWhite.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _twoFactorEnabled
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _twoFactorEnabled ? 'Secure' : 'At Risk',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _twoFactorEnabled
                              ? Colors.green[100]
                              : Colors.orange[100],
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTile(
    String title,
    String status,
    IconData icon,
    Color color,
    VoidCallback? onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: TColors.containerPrimary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColors.containerPrimary),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
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
              ),
        ),
        subtitle: Text(
          status,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
        ),
        trailing: onTap != null
            ? Icon(Icons.chevron_right, color: color)
            : FaIcon(FontAwesomeIcons.check, color: color, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAccountsList() {
    return Column(
      children:
          _userAccounts.map((account) => _buildAccountTile(account)).toList(),
    );
  }

  Widget _buildAccountTile(Map<String, dynamic> account) {
    bool isActive = account['isActive'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isActive
            ? TColors.primary.withValues(alpha: 0.1)
            : TColors.containerPrimary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? TColors.primary : TColors.containerPrimary,
          width: isActive ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: TColors.primary.withValues(alpha: 0.2),
          child: account['avatar'] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    account['avatar'],
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                )
              : FaIcon(
                  FontAwesomeIcons.user,
                  size: 20,
                  color: TColors.primary,
                ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                account['name'],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            if (isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: TColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Active',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: TColors.textWhite,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              account['email'],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              account['accountType'],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleAccountAction(value, account),
          itemBuilder: (context) => [
            if (!isActive)
              const PopupMenuItem(
                value: 'switch',
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz),
                    SizedBox(width: 8),
                    Text('Switch to this account'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edit account'),
                ],
              ),
            ),
            if (_userAccounts.length > 1)
              const PopupMenuItem(
                value: 'remove',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Remove account', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAccountButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TColors.primary.withValues(alpha: 0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showAddAccountOptions,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.plus,
                    size: 20,
                    color: TColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Add Another Account',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TColors.primary,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColors.containerPrimary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColors.containerPrimary),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Transactions',
              _totalTransactions.toString(),
              FontAwesomeIcons.receipt,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: TColors.containerPrimary,
          ),
          Expanded(
            child: _buildStatItem(
              'Categories',
              _categoriesCreated.toString(),
              FontAwesomeIcons.tags,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: TColors.containerPrimary,
          ),
          Expanded(
            child: _buildStatItem(
              'Days Active',
              _daysActive.toString(),
              FontAwesomeIcons.calendar,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        FaIcon(
          icon,
          size: 24,
          color: TColors.primary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: TColors.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: TColors.textSecondary,
              ),
          textAlign: TextAlign.center,
        ),
      ],
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
  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text(
            'Profile editing functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _verifyEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email verification sent!')),
    );
  }

  void _verifyPhone() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Phone verification code sent!')),
    );
  }

  void _toggle2FA() {
    setState(() {
      _twoFactorEnabled = !_twoFactorEnabled;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_twoFactorEnabled
            ? 'Two-factor authentication enabled'
            : 'Two-factor authentication disabled'),
      ),
    );
  }

  void _handleAccountAction(String action, Map<String, dynamic> account) {
    switch (action) {
      case 'switch':
        _switchToAccount(account);
        break;
      case 'edit':
        _editAccount(account);
        break;
      case 'remove':
        _removeAccount(account);
        break;
    }
  }

  void _switchToAccount(Map<String, dynamic> account) {
    setState(() {
      // Set all accounts to inactive
      for (var acc in _userAccounts) {
        acc['isActive'] = false;
      }
      // Set selected account to active
      account['isActive'] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switched to ${account['name']}'),
        backgroundColor: TColors.primary,
      ),
    );
  }

  void _editAccount(Map<String, dynamic> account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              controller: TextEditingController(text: account['name']),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              controller: TextEditingController(text: account['email']),
            ),
          ],
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
                const SnackBar(content: Text('Account updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _removeAccount(Map<String, dynamic> account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Account'),
        content: Text('Are you sure you want to remove ${account['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userAccounts.removeWhere((acc) => acc['id'] == account['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${account['name']} removed'),
                  backgroundColor: TColors.errorPrimary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.errorPrimary,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showAddAccountOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TColors.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Add Account',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FaIcon(
                  FontAwesomeIcons.userPlus,
                  color: TColors.primary,
                ),
              ),
              title: const Text('Create New Account'),
              subtitle: const Text('Sign up for a new account'),
              onTap: () {
                Navigator.pop(context);
                _createNewAccount();
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FaIcon(
                  FontAwesomeIcons.rightToBracket,
                  color: TColors.secondary,
                ),
              ),
              title: const Text('Login to Existing Account'),
              subtitle: const Text('Sign in with existing credentials'),
              onTap: () {
                Navigator.pop(context);
                _loginToExistingAccount();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _createNewAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Account'),
        content: const Text('New account creation would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _loginToExistingAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login to Account'),
        content: const Text('Account login would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Text(
            'Password change functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _downloadData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data download started')),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all data. This action cannot be undone.',
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
                  content: Text('Account deletion initiated'),
                  backgroundColor: Colors.red,
                ),
              );
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
}
